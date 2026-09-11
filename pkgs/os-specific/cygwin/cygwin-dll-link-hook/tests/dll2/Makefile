.PHONY: all install
all: cyghello2.dll

install: $(out)/bin/cyghello2.dll $(out)/lib/libhello2.dll.a $(out)/include/hello2.h

cyghello2.dll libhello2.dll.a: hello2.c
	$(CC) -o $@ $^ -shared -Wl,--out-implib,libhello2.dll.a -Wl,--export-all-symbols

$(out)/bin/cyghello2.dll: cyghello2.dll
	install -m755 -D $< $@

$(out)/lib/libhello2.dll.a: libhello2.dll.a
	install -m644 -D $< $@

$(out)/include/hello2.h: hello2.h
	install -m644 -D $< $@
