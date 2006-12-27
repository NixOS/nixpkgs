source $stdenv/setup

buildFlags="-f unix/Makefile generic"

installFlags="-f unix/Makefile prefix=$out INSTALL=cp"

genericBuild
