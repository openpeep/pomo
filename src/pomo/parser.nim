# Pomo is a simple PO file parser for gettext internationalization,
# that can generate JSON, BSON output or MO (Machine Object) for Nim
# 
# (c) 2022 Pomo is released under MIT License
#          Made by Humans from OpenPeep
#          
#          https://openpeep.ro
#          https://github.com/openpeep/pomo

import toktok
import std/tables

from std/strutils import `%`, strip
from std/enumutils import symbolName

include ./ast

tokens:
    COMMENT     > '#' .. EOL
    MSG_ID      > "msgid"
    MSG_STR     > "msgstr"

type
    Error* = enum
        TypeError

    FunctionHandler = proc(p: var Parser): Node {.gcsafe.}

    Parser* = object
        lexer: Lexer
            # An instance of TokTok Lexer <3
        statements: seq[Node]
            # A sequence containing all AST nodes
        prev, current, next: TokenTuple
        error: string

proc setError[T: Parser](p: var T, typeError: Error, msg: string) =
    ## Set an error message containing TypeError, line, column and the message
    p.error = "$1 ($2:$3): $4" % [$typeError, $p.current.line, $p.current.col, msg]

proc hasError*[T: Parser](p: var T): bool {.inline.} =
    ## Determine if there are any errors
    result = p.error.len != 0

proc getError*[T: Parser](p: var T): string {.inline.} =
    ## Returns the error message, if any
    result = p.error

proc isEOF[T: Parser](p: var T): bool =
    result = p.current.kind == TK_EOF

proc getSymbol(nodeType: NodeType): string =
    result = nodeType.symbolName

proc jump[T: Parser](p: var T, offset = 1) =
    ## Walk and update prev, current and next group of tokens.
    ## You can jump groups one or many times at once.
    ## By default `offset` is `1`.
    var i = 0
    while offset > i: 
        p.prev = p.current
        p.current = p.next
        p.next = p.lexer.getToken()
        inc i

proc parseText(p: var Parser): Node =
    jump p
    if p.current.kind != TK_STRING:
        p.setError(TypeError, "Missing text assignment for \"msgid\"")
        return nil

    result = Node(nodeType: NodeTypeText, nodeName: NodeTypeText.getSymbol)
    result.text = new NodeText
    result.text.msgid = p.current.value

    if p.next.kind == TK_MSG_STR:
        jump p
        if p.next.kind == TK_STRING:
            jump p
            result.text.msgstr = p.current.value
        else:
            p.setError(TypeError, "Missing text for \"msgstr\" ")
    else:
        p.setError(TypeError, "Missing translation key \"msgstr\"")

proc getPrefixFn(p: var Parser): FunctionHandler =
    ## Parse a ``msgid`` or a ``msgstr``
    if p.current.kind == TK_MSG_ID:
        result = parseText

proc parseComment(p: var Parser): Node =
    ## Parse single or multi-line comments ?
    ## TODO check specs regarding comments
    var commtext: string
    if p.current.value[0] == '#':
        commtext = p.current.value[1 .. ^1]
    else: commtext = p.current.value

    result = Node(
        nodeType: NodeTypeComment,
        nodeName: NodeTypeComment.getSymbol,
        comment: commtext.strip
    )

proc getStatements*(p: Parser): seq[Node] =
    ## Return a sequence containing all AST nodes
    result = p.statements

proc walk[P: Parser](p: var P) =
    ## Walk and parse token by token,
    ## line by line, mango by mango
    while p.hasError() == false and p.lexer.hasError == false and not p.isEOF:
        let prefixFn = p.getPrefixFn()
        if prefixFn != nil:
            p.statements.add p.prefixFn()
        else:
            if p.current.kind == TK_COMMENT:
                p.statements.add p.parseComment()
        jump p

proc po*(text: string): Parser =
    ## The main procedure to call within your app
    ## in order to parse a ``.po`` document.
    var p: Parser = Parser(lexer: Lexer.init(text))
    p.current = p.lexer.getToken()
    p.next    = p.lexer.getToken()
    p.prev    = p.current
    p.walk()
    result = p