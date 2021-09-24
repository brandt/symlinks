# Makefile for symlinks
CC      = gcc
# append options like `-o owner -g group` here if desired
INSTALL = install
CFLAGS += $(shell getconf LFS_CFLAGS 2>/dev/null)
PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man/man8
BINDIR ?= $(PREFIX)/bin


.PHONY: all
all: symlinks

symlinks: symlinks.c
	$(CC) -Wall -Wstrict-prototypes -O2 $(CFLAGS) -o symlinks symlinks.c

install: all symlinks.8
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) -m 755 symlinks $(BINDIR)
	$(INSTALL) -d $(MANDIR)
	$(INSTALL) -m 644 symlinks.8 $(MANDIR)

.PHONY: clean
clean:
	rm -f symlinks *.o core
