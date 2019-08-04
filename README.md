# polify - The most convenient way to update hookmodules on a polybar 

USAGE
-----

For **polify** to work, there needs to be at least one
module of the type `custom/ipc` and the setting `enable-ipc`
needs to be set to true in the polybar configuration file.  

`~/.config/polybar/config`  
``` text
[settings]
enable-ipc = true

...

[module/myOwnPolifyModule]
type = custom/ipc
hook-0 = polify --module myOwnPolifyModule

...
```


When polify is executed with only the `--module
MODULE_NAME` option, all it will do is `cat` the content of
the file: `/tmp/polify/MODULE_NAME` (*or `echo` a blank line
if the file doesn't exist*). When this is done from a
**polybar** module it will set the modules text to **the
last line** of the file.  

Any arguments to the `polify` command that doesn't belong
to an option, will get redirected (and formatted if needed
or requested) to `/tmp/polify/MODULE_NAME`. Then the command
`polybar-msg hook MODULE_NAME 1` will get executed by
**polify**, causing the module to get updated.

EXAMPLE:  

```
$ polify --module myOwnPolifyModule testing one three four

this will first create (or overwrite the file) /tmp/polify/myOwnPolifyModule
with the single line:
testing one three four

then the command: polybar-msg hook myOwnPolifyModule 1
is automatically executed, triggering the first hook to execute:
(polify --module myOwnPolifyModule), which in turn will update the module with the string
```



The `--expire-time SECONDS` can be used to clear the module
when SECONDS have passed, if SECONDS is `0` it will never
get automatically cleared. It is also possible to manually
clear a module with the `--clear` option.  

The text can be forced to have a specific background,
foreground or mousebutton actions. It is also possible to
prefix the string with another string, which in turn can
have different colors and actions:  

EXAMPLE:  

``` text
$ polify --module myOwnPolifyModule \
    --foreground '#FF00FF' \
    --background '#000000' \
    --rightclick 'notify-send "polify rc"' \
    --prefix "test module: " \
    --foreground-prefix '#FFF000' \
    --background-prefix '#0000FF' \
    --leftclick-prefix 'notify-send "clicking prefix"' \
    this is the main string


$ cat /tmp/polify/myOwnPolifyModule
%{F#FFF000}%{B#0000FF}%{A1:notify-send "clicking prefix":}test module: %{A}%{F-}%{B-}%{F#FF00FF}%{B#000000}%{A3:notify-send "polify rc":}this is the main string%{F-}%{B-}%{A}
```


Since only the last line of the file is the one that will
be visible in the bar, it is possible to write and read text
to the file and use them to f.i. store the state of a
module. This is conveniently done by using the `--msg
MESSAGE` option.

``` text
$ polify --module myOwnPolifyModule --msg "mode1" --foreground '#FF0000' this is mode one
$ cat /tmp/polify/myOwnPolifyModule | head -1
mode1
```


`polifymodetoggler.sh`  

``` shell
#!/bin/bash

thisscript="$(readlink -f "$0")"

if [[ $(polify --module myOwnPolifyModule | head -1) = mode1 ]]; then
    polify --module myOwnPolifyModule   \
           --leftclick "$thisscript"    \
           --foreground '#00FF00'       \
           --msg "mode2"                \
           this is mode two
else 
    polify --module myOwnPolifyModule   \
           --leftclick "$thisscript"    \
           --foreground '#FF0000'       \
           --msg "mode1"                \
           this is mode one
fi
```


If you are using multiple polybars you can use the `--pid PID` option to specify which polybar process to work with.  


OPTIONS
-------

```text
polify [OPTIONS] [MESSAGE]
polify [--module|-o TARGET-MODULE] [--pid|-p PID] [--foreground|-f COLOR] [--background|-b COLOR] [--leftclick|-l COMMAND] [--rightclick|-r COMMAND] [--middleclick|-m COMMAND] [--prefix|-e STRING [ [--foreground-prefix|-F COLOR]  [--background-prefix|-B COLOR] [--leftclick-prefix|-L COMMAND] [--rightclick-prefix|-R COMMAND] [--middleclick-prefix|-M COMMAND] ] [--expire-time|-t SECONDS] [--msg|-s MESSAGE] [MESSAGE]
polify [--module|-o TARGET-MODULE] [--pid|-p PID] --clear|-x
polify [--module|-o TARGET-MODULE] [--pid|-p PID] --update|-U
polify --help|-h
polify --version|-v
```


`--module`|`-o` TARGET-MODULE  
Name of target module

`--pid`|`-p` PID  
If set the specified polybar PID process will be used.

`--foreground`|`-f` COLOR  
Hexadecimal color value for MESSAGE foreground color.

`--background`|`-b` COLOR  
Hexadecimal color value for MESSAGE background color.

`--leftclick`|`-l` COMMAND  
COMMAND will get executed when MESSAGE is left-clicked

`--rightclick`|`-r` COMMAND  
COMMAND will get executed when MESSAGE is right-clicked

`--middleclick`|`-m` COMMAND  
COMMAND will get executed when MESSAGE is middle-clicked

`--prefix`|`-e` STRING  
PREFIX text

`--foreground-prefix`|`-F` COLOR  
Hexadecimal color value for PREFIX foreground color.

`--background-prefix`|`-B` COLOR  
Hexadecimal color value for PREFIX background color.

`--leftclick-prefix`|`-L` COMMAND  
COMMAND will get executed when PREFIX is left-clicked

`--rightclick-prefix`|`-R` COMMAND  
COMMAND will get executed when PREFIX is right-clicked

`--middleclick-prefix`|`-M` COMMAND  
COMMAND will get executed when PREFIX is middle-clicked

`--expire-time`|`-t` SECONDS  
If set module will get cleared after SECONDS

`--msg`|`-s` MESSAGE  
Will get added to the module text file before the actual
message/prefix. Can be used to store information such as the
current state of the module

`--clear`|`-x`  
Clears the module (both message and prefix) and the file.

`--update`|`-U`  

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.



