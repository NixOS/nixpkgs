. $stdenv/setup

makeFlags="-f unix/Makefile generic"

installFlags="-f unix/Makefile prefix=$out INSTALL=cp"

genericBuild
