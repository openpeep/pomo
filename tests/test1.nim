import std/[json, jsonutils]
import unittest, pomo

test "can do things":
    let contents = """
msgid "My Account"
msgstr "Contul meu"

msgid "Buy now"
msgstr "Cumpără acum"

msgid "Delete account"
msgstr "Șterge contul"
"""
    var p = parseProgram(poContents = contents)
    let statements = p.getStatements()
    check statements.len == 3
    check p.hasError == false

    echo pretty(p.getStatements().toJson(), 2)