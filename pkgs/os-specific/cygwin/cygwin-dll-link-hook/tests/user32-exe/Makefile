.PHONY: all check install
all: peek.exe

install: $(out)/bin/peek.exe

peek.exe: main.c
	$(CC) -o $@ $^ -lpeek

check: peek.exe
	./peek.exe

$(out)/bin/peek.exe: peek.exe
	install -m755 -D $< $@
