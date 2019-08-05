---
description: >
  Update polybar hookmodules in a safe and smooth way
updated:       2019-08-05
version:       2019.08.05.8
author:        budRich
repo:          https://github.com/budlabs/polify
created:       2019-03-18
type:          default
license:       mit
dependencies:  [bash, polybar,getopt]
see-also:      [bash(1), polybar(1)]
environ:
    POLIFY_DIR: /tmp/polify
synopsis: |
    --module|-o TARGET-MODULE [OPTIONS] [MESSAGE]
    --module|-o TARGET-MODULE [--pid|-p PID] [--foreground|-f COLOR] [--background|-b COLOR] [--leftclick|-l COMMAND] [--rightclick|-r COMMAND] [--middleclick|-m COMMAND] [--scrollup|-u COMMAND] [--scrolldown|-d COMMAND] [--prefix|-e STRING [ [--foreground-prefix|-F COLOR]  [--background-prefix|-B COLOR] [--leftclick-prefix|-L COMMAND] [--rightclick-prefix|-R COMMAND] [--middleclick-prefix|-M COMMAND] [--scrollup-prefix|-U COMMAND] [--scrolldown-prefix|-D COMMAND] ] [--expire-time|-t SECONDS] [--msg|-s MESSAGE] [MESSAGE]
    --module|-o TARGET-MODULE [--pid|-p PID] --clear|-x
    --help|-h
    --version|-v
...

# long_description

For **polify** to work, there needs to be at least one module of the type `custom/ipc` and the setting `enable-ipc` needs to be set to true in the polybar configuration file.  

`~/.config/polybar/config`  
```
[bar/example]
enable-ipc = true

...

[module/polifyModule1]
type = custom/ipc
hook-0 = polify --module polifyModule1

...
```

When polify is executed with only the `--module MODULE_NAME` option, all it will do is `cat` the content of the file: `/tmp/polify/MODULE_NAME` (*or `echo` a blank line if the file doesn't exist*). When this is done from a **polybar** module it will set the modules text to **the last line** of the file.  

Any arguments to the `polify` command that doesn't belong to an option, will get redirected (and formatted if needed or requested) to `/tmp/polify/MODULE_NAME`. Then the command `polybar-msg hook MODULE_NAME 1` will get executed by **polify**, causing the module to get updated.

EXAMPLE:  

```
$ polify --module polifyModule1 testing one three four
```

this will first create (or overwrite) the file: /tmp/polify/polifyModule1
with the single line:
testing one three four

then the command: `polybar-msg hook polifyModule1 1`
is automatically executed, triggering the first hook to execute:
(polify --module polifyModule1), which in turn will update the module with the string: "testing one three four"


The `--expire-time SECONDS` option can be used to clear the module when SECONDS have passed. It is also possible to manually clear a module with the `--clear` option.  

The text can be forced to have a specific background, foreground or mouse-button actions. It is also possible to prefix the string with another string, the prefix in turn can have different colors and actions:  

EXAMPLE:  

```
$ polify --module polifyModule1 \
    --foreground '#FF00FF' \
    --background '#000000' \
    --rightclick 'notify-send "polify rc"' \
    --prefix "test module: " \
    --foreground-prefix '#FFF000' \
    --background-prefix '#0000FF' \
    --leftclick-prefix 'notify-send "clicking prefix"' \
    this is the main string


$ cat /tmp/polify/polifyModule1
%{F#FFF000}%{B#0000FF}%{A1:notify-send "clicking prefix":}test module: %{A}%{F-}%{B-}%{F#FF00FF}%{B#000000}%{A3:notify-send "polify rc":}this is the main string%{F-}%{B-}%{A}
```

Since only the last line of the file is the one that will be visible in the bar, it is possible to write and read text to the file and use them to f.i. store the state of a module. This is conveniently done by using the `--msg MESSAGE` option.

```
$ polify --module polifyModule1 --msg "mode1" --foreground '#FF0000' this is mode one
$ cat /tmp/polify/polifyModule1 | head -1
mode1
```

`polifymodetoggler.sh`  

``` shell
#!/bin/bash

thisscript="$(readlink -f "$0")"

if [[ $(polify --module polifyModule1 | head -1) = mode1 ]]; then
    polify --module polifyModule1   \
           --leftclick "$thisscript"    \
           --foreground '#00FF00'       \
           --msg "mode2"                \
           this is mode two
else 
    polify --module polifyModule1   \
           --leftclick "$thisscript"    \
           --foreground '#FF0000'       \
           --msg "mode1"                \
           this is mode one
fi
```

If you are using multiple polybars you can use the `--pid PID` option to specify which polybar process to work with.  
