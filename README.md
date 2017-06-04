# atom-dict package

[![Greenkeeper badge](https://badges.greenkeeper.io/aki77/atom-dict.svg)](https://greenkeeper.io/)

Dictionary.app interface for Atom.(OSX only)
[![Build Status](https://travis-ci.org/aki77/atom-dict.svg)](https://travis-ci.org/aki77/atom-dict)

![](http://i.gyazo.com/1afbef515b76deb9969f8b57f6ea70bf.gif)

Inspired by [dictionary.vim](https://github.com/itchyny/dictionary.vim).

## Requirement
* Dictionary.app
* `gcc`

## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

```coffeescript
'atom-text-editor':
  'ctrl-c w': 'dict:search'
  'ctrl-c shift-w': 'dict:input'
```

## Settings

- `direction` (default: 'down')
