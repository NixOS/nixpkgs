.PHONY: all install
all: cyghello.dll

install: $(out)/bin/cyghello.dll $(out)/lib/libhello.dll.a $(out)/include/hello.h

cyghello.dll libhello.dll.a: hello.c
	$(CC) -o $@ $^ -shared -Wl,--out-implib,libhello.dll.a -Wl,--export-all-symbols -lhello2

$(out)/bin/cyghello.dll: cyghello.dll
	install -m755 -D $< $@

$(out)/lib/libhello.dll.a: libhello.dll.a
	install -m644 -D $< $@

$(out)/include/hello.h: hello.h
	install -m644 -D $< $@
