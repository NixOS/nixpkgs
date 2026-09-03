.PHONY: all check install
all: hello.exe

install: $(out)/bin/hello.exe

hello.exe: main.c
	$(CC) -o $@ $^

check: hello.exe
	./hello.exe

$(out)/bin/hello.exe: hello.exe
	install -m755 -D $< $@
