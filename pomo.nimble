# Package

version       = "0.1.0"
author        = "George Lemon"
description   = "A simple Gettext PO parser made with TokTok"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4.0"
requires "toktok"

task tests, "Run tests":
    exec "testament p 'tests/*.nim'"