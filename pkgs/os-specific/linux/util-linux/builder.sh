buildinputs="$patch"
. $stdenv/setup

# !!! hack; this is because $linuxHeaders/config.h includes some
# file autoconf.h.  What is that?
export NIX_CFLAGS_COMPILE="-D_LINUX_CONFIG_H $NIX_CFLAGS_COMPILE"

tar xvfz $src
cd util-linux-*
patch MCONFIG $mconfigPatch
./configure
make
export DESTDIR=$out
make install
