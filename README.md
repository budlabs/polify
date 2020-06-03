# polify - Update polybar hookmodules in a safe and smooth way 

See the live action raw uncut demonstration video on
**youtube**: <https://youtu.be/XDUQd4VN4cQ>

## installation

If you use **Arch Linux** you can get **polify** from
[AUR](https://aur.archlinux.org/packages/polify/).  

**polify** have no dependencies and all you need is the
`polify` script in your PATH. Use the Makefile to do a
systemwide installation of both the script and the manpage.  

(*configure the installation destination in the Makefile,
if needed*)

```
$ git clone https://github.com/budlabs/polify.git
$ cd polify
# make install
$ polify -v
polify - version: 2019.08.05.1
updated: 2019-08-05 by budRich
```

USAGE
-----

For **polify** to work, there needs to be at least one
module of the type `custom/ipc` and the setting `enable-ipc`
needs to be set to true in the polybar configuration file.  

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
$ polify --module polifyModule1 testing one three four
```


this will first create (or overwrite) the file:
/tmp/polify/polifyModule1 with the single line: testing one
three four

then the command: `polybar-msg hook polifyModule1 1` is
automatically executed, triggering the first hook to
execute: (polify --module polifyModule1), which in turn will
update the module with the string: "testing one three four"


The `--expire-time SECONDS` option can be used to clear the
module when SECONDS have passed. It is also possible to
manually clear a module with the `--clear` option.  

The text can be forced to have a specific background,
foreground or mouse-button actions. It is also possible to
prefix the string with another string, the prefix in turn
can have different colors and actions:  

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


Since only the last line of the file is the one that will
be visible in the bar, it is possible to write and read text
to the file and use them to f.i. store the state of a
module. This is conveniently done by using the `--msg
MESSAGE` option.  

polify is shipped with the script **polifypop**, which can
be used to execute commands on the `--msg`line. It will only
execute a command if it is prefixed with the word
**POLIPOP**. And the first argument to **polifypop** needs
to be the name of the module, it is cool to bind polifypop
to a hotkey...

```
$ polify --module polifyModule1 --msg "mode1" --foreground '#FF0000' this is mode one
$ cat /tmp/polify/polifyModule1 | head -1
mode1
```


```
$ polify --module polifyModule1 --msg "POLIPOP notify-send 'hello pop'" hello bar
$ polifypop polifyModule1
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


OPTIONS
-------

```
polify --module|-o TARGET-MODULE [OPTIONS] [MESSAGE]
polify --module|-o TARGET-MODULE [--pid|-p PID] [--foreground|-f COLOR] [--background|-b COLOR] [--leftclick|-l COMMAND] [--rightclick|-r COMMAND] [--middleclick|-m COMMAND] [--scrollup|-u COMMAND] [--scrolldown|-d COMMAND] [--prefix|-e STRING [ [--foreground-prefix|-F COLOR]  [--background-prefix|-B COLOR] [--leftclick-prefix|-L COMMAND] [--rightclick-prefix|-R COMMAND] [--middleclick-prefix|-M COMMAND] [--scrollup-prefix|-U COMMAND] [--scrolldown-prefix|-D COMMAND] ] [--expire-time|-t SECONDS] [--msg|-s MESSAGE] [MESSAGE]
polify --module|-o TARGET-MODULE [--pid|-p PID] --clear|-x
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

`--scrollup`|`-u` COMMAND  
COMMAND will get executed when MESSAGE is scrolled up.

`--scrolldown`|`-d` COMMAND  
COMMAND will get executed when MESSAGE is scrolled down.

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

`--scrollup-prefix`|`-U` COMMAND  
COMMAND will get executed when PREFIX is scrolled up.

`--scrolldown-prefix`|`-D` COMMAND  
COMMAND will get executed when PREFIX is scrolled down.

`--expire-time`|`-t` SECONDS  
If set module will get cleared after SECONDS

`--msg`|`-s` MESSAGE  
Will get added to the module text file before the actual
message/prefix. Can be used to store information such as the
current state of the module

`--clear`|`-x`  
Clears the module.

`--help`|`-h`  
Show help and exit.

`--version`|`-v`  
Show version and exit.

UPDATES
-------

#### 2019.08.05.0

Added polifypop.

#### 2019.08.05.0


Initial release.



LICENSE
-------

**polify** is licensed with the **MIT license**


