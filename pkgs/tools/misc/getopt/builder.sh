source $stdenv/setup
installFlags="prefix=$out"
makeFlags="CFLAGS=-DWITHOUT_GETTEXT LIBCGETOPT=0"
genericBuild
