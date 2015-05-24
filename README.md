# atom-dict package

Dictionary.app interface for Atom.(OSX only)

![](http://i.gyazo.com/ef95b3e62efb96bad6d3271264f11845.gif)

Inspired by [dictionary.vim](https://github.com/itchyny/dictionary.vim).

## Requirement
* Dictionary.app
* `gcc`

## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

```coffeescript
'atom-text-editor':
  'ctrl-c w': 'dict:dictionary'
```

## Settings

- `direction` (default: 'down')
