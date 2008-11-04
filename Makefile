# contents: Dialog Death Makefile.
#
# Copyright © 2008 Nikolai Weibull <now@bitwi.se>

.PHONY: all

BINS = \
      bin/dialog-death.exe

all: $(BINS) installer/Setup.exe

bin installer:
	mkdir $@

bin/%.exe: %.ahk bin compiler/autohotkeysc.bin
	compiler/ahk2exe.exe /in $< /out $@ /NoDecompile

installer/Setup.exe: install.nsi installer $(BINS) installer/dialog-death.ini
	makensis.exe $<

installer/dialog-death.ini: dialog-death.ini Makefile installer
	echo -n $$'\xef\xbb\xbf' | cat - $< | iconv -t UTF-16LE > $@
