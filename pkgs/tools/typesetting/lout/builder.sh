#!/bin/sh

# Prepare a makefile specifying the appropriate output directories.

source "$stdenv/setup" || exit 1

nixMakefile="nix-makefile"

unpackPhase &&									\
cd lout-*.* &&									\
cat makefile |									\
  sed -e "s|^PREFIX[[:blank:]]*=.*\$|PREFIX = $out|g ;				\
          s|^LOUTLIBDIR[[:blank:]]*=.*$|LOUTLIBDIR = \$(PREFIX)/include|g ;	\
	  s|^LOUTDOCDIR[[:blank:]]*=.*$|LOUTDOCDIR = \$(PREFIX)/doc|g ;		\
	  s|^MANDIR[[:blank:]]*=.*$|MANDIR = \$(PREFIX)/man|g"			\
  > "$nixMakefile" &&								\
mkdir -p "$out/bin" &&								\
make -f "$nixMakefile" install
