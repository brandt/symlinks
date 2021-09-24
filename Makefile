# Makefile for symlinks
CC      = gcc
INSTALL = install
CFLAGS += $(shell getconf LFS_CFLAGS 2>/dev/null)
OWNER   = root
GROUP   = root
PREFIX ?= /usr/local
MANDIR ?= $(PREFIX)/share/man/man8/symlinks.8
BINDIR ?= $(PREFIX)/bin


.PHONY: all
all: symlinks

symlinks: symlinks.c
	$(CC) -Wall -Wstrict-prototypes -O2 $(CFLAGS) -o symlinks symlinks.c

install: all symlinks.8
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 755 symlinks $(BINDIR)
	$(INSTALL) -c -o $(OWNER) -g $(GROUP) -m 644 symlinks.8 $(MANDIR)

.PHONY: clean
clean:
	rm -f symlinks *.o core
