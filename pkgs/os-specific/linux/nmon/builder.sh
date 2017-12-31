source $stdenv/setup

CFLAGS="-g -O3 -Wall -D JFS -D GETUSER -D LARGEMEM"
LDFLAGS="-lncurses -lm -g"

cc -o nmon $src $CFLAGS $LDFLAGS -D X86

mkdir -p $out/bin

mv nmon $out/bin

