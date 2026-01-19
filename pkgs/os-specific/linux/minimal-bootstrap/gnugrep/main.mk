# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-FileCopyrightText: 2022 Samuel Tyler <samuel@samuelt.me>
#
# SPDX-License-Identifier: GPL-3.0-or-later

PACKAGE=grep
VERSION=2.4

CC      = tcc
LD      = tcc
AR      = tcc -ar

CFLAGS  = -DPACKAGE=\"$(PACKAGE)\" \
          -DVERSION=\"$(VERSION)\" \
          -DHAVE_DIRENT_H=1 \
          -DHAVE_UNISTD_H=1 \
          -DHAVE_STRERROR=1 \
          -DSTDC_HEADERS=1

.PHONY: all

GREP_SRC = grep dfa kwset obstack regex stpcpy savedir getopt getopt1 search grepmat
GREP_OBJECTS = $(addprefix src/, $(addsuffix .o, $(GREP_SRC)))

all: grep egrep fgrep

grep: $(GREP_OBJECTS)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

egrep: $(GREP_OBJECTS) src/egrepmat.c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

fgrep: $(GREP_OBJECTS) src/fgrepmat.c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

install: all
	install -D grep $(DESTDIR)$(PREFIX)/bin/grep
	install -D egrep $(DESTDIR)$(PREFIX)/bin/egrep
	install -D fgrep $(DESTDIR)$(PREFIX)/bin/fgrep
