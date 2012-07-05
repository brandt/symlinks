# Makefile for symlinks

CC = gcc
 
all: symlinks

symlinks: symlinks.c
	$(CC) -Wall -Wstrict-prototypes -O2 ${CFLAGS} -o symlinks symlinks.c
 
install: all symlinks.8
	install -m 755 -o root -g root symlinks /usr/local/bin
	install -m 644 -o root -g root symlinks.8 /usr/local/man/man8

clean:
	rm -f symlinks *.o core
