#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#00ffccff'  # default
T='#00eeeeee'  # text
W='#880000bb'  # wrong
V='#00564dbb'

scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 -spread 6 /tmp/screenshotblur.png
rm /tmp/screenshot.png

/usr/bin/i3lock \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 1                 \
--ignore-empty-password    \
--show-failed-attempts     \
--pass-media-keys          \
--pass-screen-keys         \
--pass-power-keys          \
-i /tmp/screenshotblur.png \
--blur 7                   \
--radius 120               \
--clock                    \
--indicator                \
--timestr="%H:%M:%S"       \
--datestr="%A, %m %Y"      \
--keylayout 2              \