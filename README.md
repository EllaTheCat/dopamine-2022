qb# README.md

## dopamine-2022

4th in a series of git repositories brought to you by EllatheCat and
Parkinson's Disease, the chronic condition that just keeps on giving
(kicks in the teeth).

dopamine-2022 instantly deprecates its predecessors. As of 2022-10-31
dopamine-2022 lets you operate a computer running the tiling window
manager i3 (or possibly sway) without any of the keyboard modifiers
{Mod5,Mod4,Mod3,Mod2,Mod1} whatsoever.

## Programming with Parkinson's

Inadvertent tremors or spasms cause typos. A typical typo might be the
random insertion of the letters XS. This is caused by typing control-X
control-S to save a file in emacs, hitting shift instead of control,
and trying again because the save wasn't confirmed. Sometimes the XS
lands inside a comment, no lasting harm done, but if it ends up in
code nasty surprises can occur. XS and Q are hard to spot.

Medication induces drowsiness. I have woken after a split-second of
narcolepsy with a keyboard dent in my forehead to see my work has been
corrupted in spectacular fashion.

oops: My decision to put the 1st and 2nd mode select keys (q.v.) in
the key cluster at bottom left hasn't helped with typos. My reasoning
was that the mode select keys should go where the modifier keys are
clustered.

## git for PD

git lets me recover my work after a.o. narcolepsy accidents.

git lets us share. This is fine until a project not unlike this one
needs to adapt to several users, and then things get interesting.

## Make for shellcheck

i3 runtime files have standard locations, In fact, a given file might
have several standard locations ;) Putting files in the right places with
the right permissions is called deployment.

A local git repo lives in a single directory under a toplevel
directory.  Deploying this program could be a simple matter of writing
a script ; using the 'install' utiity wold make it easier, it both
copies and sets permissions. I chose to use 'make' instead.

Make is not popular with the cool kids in 2022, which is a shame. I
think I'm competent enough to write a Makefile that other people can
read and understand, that builds its targets correctly. Nevertheless
make versus a script smells of over-engineering.

## The Parkinsonian spanner-in-the-works

Cognitive decline deoesn't turn a developer into a slack-jawed yokel.

The sensation is that of "having something on the tip of your tongue";
you feel that you ought to know. I remember it well when I first
noticed my inability to visualise gyroscopic precession during an
interview. I wasn't expected to have the maths sklls, just be able to
say "which way does it go when you push it here?".

As far as writing an i3 config that suits my workflow goes, cognitive
decline means more stupid mistakes and misconceptions. Imposter
syndrome writ large.

ShellCheck https://www.shellcheck.net/ is a utility for reporting how
well a bash program follows "best practice" rules.

The Makefile won't let me deploy anything built with bash that hasn't
been reviewed and approved by shellcheck. If anyone understands the
principle, "i3configcheck" would be nice to have.

# FEATURES

## One Handed Operation
One-Handed Operation is facilitated by using i3 modes with bindings that
don't require a modifier key.

## Major Modes
There are 4 major modes in addition to default: $Primary, $AltPrimary, $Secondary, $AltSecondary.  There are TWO keys for changing mode, the 1st and 2nd mode
select keys.

- (1st) EITHER the backslash key next to Z OR the Menu key.
- (2nd) The Super_L key

Experience has shown that the 1st and 2nd mode keys should work like this
in conjunction with the space bar

- The 1st mode key toggles between Primary and AltPrimary modes.
  In default mode and the other two major modes it selects Primary mode.

- The 2nd mode key toggles between Secondary and AltSecondary modes.
  In default mode and the other two major modes it selects Secondary mode.

- The space bar, without exception, switches from any other mode to
  default mode.

I've tried to make performance not too shabby for mainstreanm i3 users seeking
better productivity, obviously  all I can say is tie one arm behind your back
when you evaluate :)

## Secondary mode

Press Secondary, type two characters, it looks for a command or a
workspace with a matching two character shortcut, then runs the
command or visits the workspace. If the workspace has an associated
application not already running it is launched. Entering a valid two
character command uses a state machine with 27 i3 modes with aaprox
26*36 = 936 bindsym combinations.

Press Secondary to enter AltSecondary, you can (m) visit a 3 digit
mark, (x) swap container with a marked container. Nearly all
containers are automagically marked and the mark is on the title
bar. Entering 3 digits uses a state machine with 111 i3 modes with
approx 10*10*10 = 1000 bindsym combinations. You can also (w) visit
numbered workspaces in the range 10 to 99 and (c) send a container to
such a workspace.

## Minor modes

A minor mode is one that cannot be reached direcly from default
mode. Ideally, the longer the key sequence, the more powerful the
command; the shorter the key sequence, the faster the command. I only
have "gut feel" and "suck it and see" in my ergonomics toolkit.

Even worse, my workflow reducs to moving containers to workspaces and
workspaces to outputs. I don't find myself navigating the i3 tree like
a boss at all. There's a case for sticking with the standard bindings
for the fiddly tasks!

However I partition the minor modes I can't please all the people all
the time. What I have done is give it my best shot and commented my
thoughts.

It follows that the user needs an accurate sense of what is the
current mode, and that is why there needs to be a binding mode
indicator.

## Binding Mode Indicator

There are two. First, the i3bar shows the current binding mode in a
dedicated tab next to the workspace tabs, with black text on a livid
yellow background. The binding mode tab also shows the bound keys for
the current mode. Second, a notify-send is emitted after each binding
mode change; this is a hook for users who don't want i3bar or don't
want tabs.

Apropos of cognitive decline and experiencing the "on the tip of my
tongue" feeling, using the BMI to show bound keys even without saaying
what they are bound to helps considerably. Clustering also helps,
compare "wasd hjkl" vs "adshjklw".

## i3 config digest

If the BMI is too terse, there is the digest.  THe digest is a listing
of bindings accessible from Primary and Tertiary modes, plus a list of
Secondary mode commands. The digest is automatically constructed from
the deployed config file by 'make'.

It is also possible to pop up the deployed config file with line
numbers that correlate with the line numbers in the error messages
from red nagbars. This is to acknowldge that the etc-included files
mess up the line numbering.

## Editor Preferences
I use Emacs by default, so this document looks at Emacs in the context
of i3 and my PD. I do use (neo)vi(m) for system admin and git
commits.. I've eschewed some Emacs features in favour of ones that are
usable with either editor. The best example is toggling between an
editor window and a terminal running make rather than using M-x
compile or whatever.

## Emacs Inside

An instance of "Emacs inside" consists of xfce4-terminal with 3 tabs;
the 1st tab is Emacs, the 2nd tab is a bash shell for running make and
git; the 3rd tab is spare. The tabs can be selected by Alt +
&lt;;digit;&gt;.  My workflow is vulnerable to RSI whenever I use the
mouse to switch between Emacs and terminal. Alt-1 and Alt-2 work
really well instead.

Each instance of Emacs inside is tied to a workspace, and you can have
up to 10 instances, e0,e1,..,e9.  Each instance can be shown or hidden
independent of the others. The show and hide transitions are animated,
(I just hammer the system by redrawing the floating window rectangle at
the appropriate sizes during the transition, this isn't Sway ;-)

## Numbered Workspaces.

A two character string that matches ":isdigit: :isdigit:" (the numbers
from 10 to 99) identifies a numbered workspace.

## Command aliases

A two character string that matches ":islower: :islower:" or
":islower: :isdigit:" is called a "command alias" or a "named
workspace", whichever seems appropriate. There are two types:

### Applications with dedicated named workspaces

A command like 'thunderbird' or 'handbrake' has a command alias, 'tb' or
'hb' respectively, that focuses the running app, launches the app if not
running beforehand, and (crucially) occupies over half of the screen
such that the command alias 'xy' is synonymous with named workspace 'xy'.
Emacs inside e0...e9 are in this category.

### Applications without dedicated workspaces

There are command aliases 'pq' that do not have a dedicated named workspace
workspace; they can have associated workspaces but it's not formalised.

These 'pq' are declared and defined in the $not_wsaapps dictionary inside cfg/apps00.

##  Using i3 with Parkinsons

## Prompts
In addition to the Binding Mode Indicator prompts, there are prompts
for the Secondary mode, obtained by typing "secondary mode z z". A
dmenu at the bottom shows about 70 command aliases and the prompt "Esc
to Quit, Return for help". Select an item from the list then type
return and the list is replaced by a long line of help text for the
chosen command alias, and the prompt says ""Esc to Quit, Return to
invoke". Type Return and the command alias is invoked.

## Lists
You want to move a workspace to an output. What if you know it's there
but you can't see it? This might be the case when one of your two
monitors is also a television and the workspace is on the monitor
output? What if you have more outputs than screens?  What if PD makes
you appreciate any help you can get?

Typing "primary mode w runs "move workspace interactive" which puts up
a dmenu listing all workspaces grouped by output. Select an output and
a workspace and the workspace moves to that output. There are several
dmenu assisted operations,

move_workspace_to_output_interactive,
swap_two_workspaces_by_reference,
swap_two_containers_by_value,
dismiss_workspace_interactive.

# Summary

If I prevaricate as I have been doing this will never ship. I am
therefore putting what I have up on github. I don't wish to offend, but
the subtext of this project is two words:

<details>
  <summary>NSFW Spoiler</summary>

 "Fuck Parkinson's."

</details>
EllaTheCat
