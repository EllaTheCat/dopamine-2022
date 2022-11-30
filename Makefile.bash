#!/bin/bash
#
# Makefile.bash - non-trivial bash functions called from Makefile.
#
# - This is a build-time utility not a runtime config or runtime executable.


#
# - unwrap wrapped lines.
# - map HDMI2,HDMI1,VGA1 to $3,$4,$5
#
function i3-config
{

    # A common use case is dual monitors on HDMI2 and HDMI1 that need to be swapped:
    #
    # YOU have HDMI2 HDMI1 VGA1
    # You want HDMI1 HDMI2 VGA1
    #
    # This happens because the ist pass output HDMI1 matches the 2nd pass input HDMI1:
    #
    # HDMI1 HDMI1 VGA1
    # HDMI2 HDMI2 VGA1
    # HDMI2 HDMI2 VGA1

    # sed ':x; /\\$/ { N; s/\\\n//; tx }'
    # https://unix.stackexchange.com/questions/13676/how-can-you-combine-all-lines-that-end-with-a-backslash-character

    # Collapse 2 or more spaces or tabs to 2 spaces thus preserving 1st level indentation
    # https://superuser.com/questions/112834/how-to-match-whitespace-in-sed

    hdmi2=$(printf "s/hdmi2/%s/g" $3)
    hdmi1=$(printf "s/hdmi1/%s/g" $4)
    vga1=$(printf "s/vga1/%s/g" $5)

    cat "$1" | sed ':x; /\\$/ { N; s/\\\n//; tx }' | \
        sed s/HDMI/hdmi/g | sed s/VGA/vga/g | \
        sed "$hdmi2"| sed "$hdmi1"| sed "$vga1" | \
        sed -e 's/[[:blank:]]\{3,\}/  /g' | tee "$2"
}

#
# Start here.
#

i3-config "$1" "$2" "$3" "$4" "$5"

#
# Done.
#
