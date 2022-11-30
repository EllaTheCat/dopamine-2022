#
# Makefile for dopamine-2022
#
# Requires : shellcheck
# HOWTO : Skip to last screenful of this file.

SHELL=/bin/bash

#================================================================

# I have two monitors, on HDMI2 and HDMI1 respectively.
# I also have one dummy monitor plug on VGA1.
# Reading their outputs' names left to right: HDMI2 HDMI1 VGA1
# Put your output names into here in place of mine (quoted)

H2="HDMI2"
H1="HDMI1"
V1="VGA1"

#================================================================

# Local git repo directory, where the Makefile lives
DOPAMINE=$(shell readlink -f $(shell pwd))

DOPAMINE_BINDIR=$(DOPAMINE)/bin
DOPAMINE_CFGDIR=$(DOPAMINE)/cfg

# i3 is invoked from files deployed in various locations:
RUNTIME_BINDIR=$(HOME)/local/i3/bin
RUNTIME_CFGDIR=$(HOME)/local/i3/cfg

# The i3 config file, deployed,
RUNTIME_CFGFILE=$(HOME)/.i3/config
# The i3status config file, deployed.
RUNTIME_STATUSCFGFILE=$(HOME)/.i3status.conf

# Install permissions for: directories, executables, configurations.
RUNTIME_DIRMODE=755
RUNTIME_EXEMODE=755
RUNTIME_CFGMODE=644

# The title of the window (tab) in which this make is being run.
MAKETABNAME=$(shell xdotool getwindowfocus getwindowname)

# Snapshots created by 'make dropbox'.
# Format string must sort chronologically:
# year iso-week-number day-of-the-iso-week-number hour-of-the-day
TARFILE=i3-$(shell date +"%Y%V%u%H%M").tar

#================================================================

all: .installdirs .installcfg .installbin .installbinplus .installflags .installdigest

dropbox : .dropbox

# Remove all intermediate products excepting those that are reset here.
# Never ever delete archives unless by hand.
clean :
	@rm -f $(RUNTIME_BINDIR)/* $(RUNTIME_CFGDIR)/* $(RUNTIME_CFGFILE)
	@rm -f $(RUNTIME_STATUSCFGFILE)
	@rm -f $(DOPAMINE_BINDIR)/*.tmp $(DOPAMINE_BINDIR)/*.inc $(DOPAMINE_BINDIR)/*.log
	@rm -f $(DOPAMINE_CFGDIR)/*.tmp $(DOPAMINE_CFGDIR)/*.inc $(DOPAMINE_CFGDIR)/*.log
	@rmdir $(RUNTIME_BINDIR) $(RUNTIME_CFGDIR)
	@touch reload
	@touch restart

#================================================================

.installdirs: $(RUNTIME_BINDIR) $(RUNTIME_CFGDIR)

.installcfg: $(RUNTIME_CFGFILE) $(RUNTIME_STATUSCFGFILE)

.installbin: $(RUNTIME_BINDIR)/i3-status-wrapper $(RUNTIME_BINDIR)/i3-config-bash

.installbinplus: \
$(RUNTIME_BINDIR)/i3-dispatcher \
$(RUNTIME_BINDIR)/i3-file-watcher \
$(RUNTIME_BINDIR)/i3-focus-app-by-alias \
$(RUNTIME_BINDIR)/i3-marks \
$(RUNTIME_BINDIR)/i3-numeric \
$(RUNTIME_BINDIR)/etc-tvheadend

.todo: \
$(RUNTIME_BINDIR)/i3-recorder

.installflags: \
reloaded restarted

.installdigest: \
digest

#================================================================

# .installdirs

$(RUNTIME_CFGDIR):
	@install -m $(RUNTIME_DIRMODE) -d $(HOME)/local/i3/cfg

$(RUNTIME_BINDIR):
	@install -m $(RUNTIME_DIRMODE) -d $(HOME)/local/i3/bin

#================================================================

# .installcfg

# In dopamine-2022, i3 assembles the full config privately from
# certain partial config files. Make knows when such a partial config
# has changed. Re-install of the full config is forced
#
# Adopting the user's output names requires the Makefile.bash here.

$(RUNTIME_CFGFILE): $(DOPAMINE)/config.inc \
    $(RUNTIME_CFGDIR)/cfg07 $(RUNTIME_CFGDIR)/cfg08
	@./Makefile.bash $(DOPAMINE)/config.inc $(DOPAMINE)/config.tmp \
    $(H2) $(H1) $(V1) >/dev/null
	@install -m $(RUNTIME_CFGMODE) $(DOPAMINE)/config.tmp $@
	@touch reload
	@touch restart

# The i3 include method needs the included files to be deployed.
# Adopting the user's output names requires the Makefile.bash here.

$(RUNTIME_CFGDIR)/cfg07: $(DOPAMINE_CFGDIR)/cfg07
	@./Makefile.bash $< $<.tmp $(H2) $(H1) $(V1) >/dev/null
	@install -m $(RUNTIME_CFGMODE) $<.tmp $@
	@touch reload
	@touch restart

# Take care to modify this rule should output names appear in the file
# (they do not at present).

$(RUNTIME_CFGDIR)/cfg08: $(DOPAMINE_CFGDIR)/cfg08
	@install -m $(RUNTIME_CFGMODE) $< $@
	@touch reload
	@touch restart

# In dopamine-2022. make can insert certain partial config files
# directly into the main config. The .inc file accumulates these.

$(DOPAMINE)/config.inc: $(DOPAMINE)/config \
    $(DOPAMINE)/cfg/keys00 $(DOPAMINE)/cfg/cfg03 $(DOPAMINE)/cfg/cfg06
	@cp $(DOPAMINE)/config $(DOPAMINE)/config.inc
	@sed -e '/###INSERT_KEYS00_HERE###/ {' -e 'r cfg/keys00' -e 'd' -e '}' \
         -i   $(DOPAMINE)/config.inc
	@sed -e '/###INSERT_CFG03_HERE###/ {' -e 'r cfg/cfg03' -e 'd' -e '}' \
         -i   $(DOPAMINE)/config.inc
	@sed -e '/###INSERT_CFG06_HERE###/ {' -e 'r cfg/cfg06' -e 'd' -e '}' \
         -i   $(DOPAMINE)/config.inc

$(RUNTIME_STATUSCFGFILE):  $(DOPAMINE_CFGDIR)/dot-i3-status.conf
	@install -m $(RUNTIME_CFGMODE) $< $@

# .installbin

# Adopting the user's output names requires the Makefile.bash here.
# There are no includes in this file but the hooks are here
$(RUNTIME_BINDIR)/i3-config-bash: \
    $(DOPAMINE_BINDIR)/i3-config-bash.inc \
    $(DOPAMINE_BINDIR)/i3-config-bash.log
	@./Makefile.bash $< $<.tmp $(H2) $(H1) $(V1) >/dev/null
	@install -m $(RUNTIME_EXEMODE) $<.tmp $@

$(DOPAMINE_BINDIR)/i3-config-bash.inc: $(DOPAMINE_BINDIR)/i3-config-bash
	@cp $< $@

$(DOPAMINE_BINDIR)/i3-config-bash.log: $(DOPAMINE_BINDIR)/i3-config-bash
	@shellcheck $(DOPAMINE_BINDIR)/i3-config-bash > $@

# Special case: When the i3bar is modified i3 must be restarted.
$(RUNTIME_BINDIR)/i3-status-wrapper: \
   $(DOPAMINE_BINDIR)/i3-status-wrapper \
   $(DOPAMINE_BINDIR)/i3-status-wrapper.log
	@install -m $(RUNTIME_EXEMODE) $(DOPAMINE_BINDIR)/i3-status-wrapper $@
	@touch reload
	@touch restart

$(DOPAMINE_BINDIR)/i3-status-wrapper.log: $(DOPAMINE_BINDIR)/i3-status-wrapper
	@shellcheck $(DOPAMINE_BINDIR)/i3-status-wrapper > $@

# Special case: The $wsapps lists are etc-included into this file
$(RUNTIME_BINDIR)/i3-focus-app-by-alias: \
    $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc \
    $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.log \
    $(DOPAMINE_CFGDIR)/apps00
	@install -m $(RUNTIME_EXEMODE) $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc $@

$(DOPAMINE_BINDIR)/i3-focus-app-by-alias.log: $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc
	@shellcheck $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc > $@

# In dopamine-2022. make can insert certain partial config files
# directly into a script before running shellcheck.

$(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc: \
    $(DOPAMINE_BINDIR)/i3-focus-app-by-alias $(DOPAMINE_CFGDIR)/apps00
	@cp $(DOPAMINE_BINDIR)/i3-focus-app-by-alias  $@
	@sed -e '/###INSERT_APPS00_HERE###/ {' -e 'r cfg/apps00' -e 'd' -e '}' \
         -i   $(DOPAMINE_BINDIR)/i3-focus-app-by-alias.inc

# .installbinplus
#
# Using a pattern rule avoids the need for editing the Makefile when
# the user adds or removes a script. Shellcheck errors will prevent
# installation.

$(RUNTIME_BINDIR)/%: $(DOPAMINE_BINDIR)/%
	@shellcheck $< > $(DOPAMINE_BINDIR)/shellcheck.log
	@install -m $(RUNTIME_EXEMODE) $< $@

# .installflags
#
# This empty target (Make 4.8) ensures that i3 restart happens no more
# than once and after everything else. IMPORTANT: 'restart' & 'reload'
# are empty FILES that must exist before running 'make'. In case of an
# error requiring user to exit i3 to regain control, 'make' cannot
# access the i3 ipc socket so you may need to logout-and-login after a
# succesful make.

reloaded: reload
	@i3-msg "reload"
	@touch $@

restarted: restart
	@i3-msg "restart"
	@touch $@

#===============================================================

digest:
	@i3-config-bash config write

#===============================================================

# When burning midnight oil, use the 'dropbox' target to save your
# hard work. The folder is tarballed and the tarball is archived.

.dropbox:
	@rm -f i3-?????????.tar
	@tar cf "$(HOME)/$(TARFILE)" -C $(DOPAMINE) $(DOPAMINE)
	@mv $(HOME)/$(TARFILE) $(HOME)/Dropbox/

#===============================================================

# HOWTO build i3 config with make from inside Emacs

# 1. Emacs invoked with command secondary e0.
# 2. Emacs in a 90% fullscreen sized i3wm floating xfce4-terminal with 3 tabs
# 3. Type Alt-1 for Emacs tab
# 4. Type Alt-2 for shell tab
# 5. in shell tab
# 6. cd <dopamine-2022>
# 7. make clean
# 8. make
# 9. cat bin/*log (if make fails)
# 10.Type Alt-1 for Emacs tab
#
# reduces to
#
# 1. Alt-2
# 2. make
# 3. Alt-1
#
# Of course you can arrange for 'vi' or similar in tab 1, which is why
# I am not using the Emacs compile window.

#===============================================================

#
# Done.
#
