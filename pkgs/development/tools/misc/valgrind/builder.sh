. $stdenv/setup || exit 1

# !!! hack; this is because $linuxHeaders/config.h includes some
# file autoconf.h.  What is that?
export NIX_CFLAGS_COMPILE="-D_LINUX_CONFIG_H $NIX_CFLAGS_COMPILE"

tar xvfj $src || exit 1
cd valgrind-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
