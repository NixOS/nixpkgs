. $stdenv/setup

export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$ncurses/include/ncurses"

preInstall=preInstall
preInstall() {
    ensureDir "$prefix/bin"
    ensureDir "$prefix/sbin"
    ensureDir "$prefix/lib"
    ensureDir "$prefix/share/man/man1"
    ensureDir "$prefix/share/man/man5"
    ensureDir "$prefix/share/man/man8"
}

genericBuild

