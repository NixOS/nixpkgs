# Prepare a makefile specifying the appropriate output directories.
#
# Written by Ludovic Courtès <ludo@gnu.org>.

source "$stdenv/setup" || exit 1

nixMakefile="nix-makefile"

# Build and install documentation, PS and PDF.
installDoc ()
{
  echo "building and installing documentation..."
  for doc in design expert slides user
  do
    echo "building \`$doc' document..."
    if [ ! -f "doc/$doc/outfile.ps" ]
    then
      ( PATH="$PWD:$PATH" ;				\
        cd "doc/$doc" && lout -r4 -o outfile.ps all )	\
      || return 1
    fi
    cp "doc/$doc/outfile.ps" "$out/doc/lout/$doc.ps" &&		\
    ps2pdf -dPDFSETTINGS=/prepress -sPAPERSIZE=a4		\
           "doc/$doc/outfile.ps" "$out/doc/lout/$doc.pdf"
  done

  return 0
}

unpackPhase &&									\
cd lout-*.* &&									\
cat makefile |									\
  sed -e "s|^PREFIX[[:blank:]]*=.*\$|PREFIX = $out|g ;				\
          s|^LOUTLIBDIR[[:blank:]]*=.*$|LOUTLIBDIR = \$(PREFIX)/lib/lout|g ;	\
	  s|^LOUTDOCDIR[[:blank:]]*=.*$|LOUTDOCDIR = \$(PREFIX)/doc/lout|g ;	\
	  s|^MANDIR[[:blank:]]*=.*$|MANDIR = \$(PREFIX)/man|g"			\
  > "$nixMakefile" &&								\
mkdir -p "$out/bin" && mkdir -p "$out/lib"					\
mkdir -p "$out/man" && mkdir -p "$out/doc/lout" &&				\
make -f "$nixMakefile" CC=cc install installman &&					\
installDoc &&									\
fixupPhase
