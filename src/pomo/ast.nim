# Pomo is a simple PO file parser for gettext internationalization,
# that can generate JSON, BSON output or MO (Machine Object) for Nim
# 
# (c) 2022 Pomo is released under MIT License
#          Made by Humans from OpenPeep
#          
#          https://openpeep.ro
#          https://github.com/openpeep/pomo

type
    NodeType* = enum
        NodeTypeText, NodeTypeComment

    NodeText = ref object
        msgid: string
            ## The keyword msgid contains the original
            ## string (usually in English for software),
        msgstr: string
            ## The keyword msgstr denotes the string
            ## which to become the translation, also double-quoted

    Node = ref object
        nodeName: string
            ## A symbol name of ``NodeType``
        case nodeType: NodeType
        of NodeTypeText:
            text: NodeText
        of NodeTypeComment:
            comment: string

