.PHONY: all install
all: cygpeek.dll

install: $(out)/bin/cygpeek.dll $(out)/lib/libpeek.dll.a $(out)/include/peek.h

cygpeek.dll libpeek.dll.a: peek.c
	$(CC) -o $@ $^ -shared -Wl,--out-implib,libpeek.dll.a -Wl,--export-all-symbols

$(out)/bin/cygpeek.dll: cygpeek.dll
	install -m755 -D $< $@

$(out)/lib/libpeek.dll.a: libpeek.dll.a
	install -m644 -D $< $@

$(out)/include/peek.h: peek.h
	install -m644 -D $< $@
