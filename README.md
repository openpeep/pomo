<p align="center">
    <img src="https://raw.githubusercontent.com/openpeep/pomo/main/.github/logo.png" width="140px"><br>
    A simple Gettext <code>.PO</code> / <code>.POT</code> parser written in Nim language 👑<br>
</p>

## 😍 Key Features
- [ ] Multiline strings and headers
- [ ] Pluralization rules
- [x] Made with [TokTok](https://github.com/openpeep/toktok), a generic tokenizer for Nim language 
- [x] Open Source | `MIT` License

## Installing
```
nimble install pomo
```

## Examples

```nim
import pomo
    let contents = """
msgid "My Account"
msgstr "Contul meu"

msgid "Buy now"
msgstr "Cumpără acum"

msgid "Delete account"
msgstr "Șterge contul"
"""

var p = po(text = contents)

```

## Roadmap
_to add roadmap_

### ❤ Contributions
If you like this project you can contribute to this project by opening new issues, fixing bugs, contribute with code, ideas and you can even [donate via PayPal address](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C) 🥰

### 👑 Discover Nim language
<strong>What's Nim?</strong> Nim is a statically typed compiled systems programming language. It combines successful concepts from mature languages like Python, Ada and Modula. [Find out more about Nim language](https://nim-lang.org/)

<strong>Why Nim?</strong> Performance, fast compilation and C-like freedom. We want to keep code clean, readable, concise, and close to our intention. Also a very good language to learn in 2022.

### 🎩 License
Pomo is an Open Source Software released under `MIT` license. [Developed by Humans from OpenPeep](https://github.com/openpeep).<br>
Copyright &copy; 2022 OpenPeep & Contributors &mdash; All rights reserved.

<a href="https://hetzner.cloud/?ref=Hm0mYGM9NxZ4"><img src="https://openpeep.ro/banners/openpeep-footer.png" width="100%"></a>
