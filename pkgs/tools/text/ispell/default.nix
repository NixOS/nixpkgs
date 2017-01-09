{ stdenv, fetchurl, bison, ncurses }:

stdenv.mkDerivation rec {
  name = "ispell-3.3.02";
  src = fetchurl {
    url = "http://fmg-www.cs.ucla.edu/geoff/tars/${name}.tar.gz";
    sha256 = "1d7c2fqrdjckp91ajpkn5nnmpci2qrxqn8b6cyl0zn1afb9amxbz";
  };
  buildInputs = [ bison ncurses ];
  patches = [
    ./patches/0005-Do-not-reorder-words.patch
    ./patches/0007-Use-termios.patch
    ./patches/0008-Tex-backslash.patch
    ./patches/0009-Fix-FTBFS-on-glibc.patch
    ./patches/0011-Missing-prototypes.patch
    ./patches/0012-Fix-getline.patch
    ./patches/0013-Fix-man-pages.patch
    ./patches/0021-Fix-gcc-warnings.patch
    ./patches/0023-Exclusive-options.patch
    ./patches/0024-Check-tempdir-creation.patch
    ./patches/0025-Languages.patch
    ./patches/0030-Display-whole-multibyte-character.patch
  ];
  postPatch = ''
    cat >> local.h <<EOF
    #define USG
    #define TERMLIB "-lncurses"
    #define LANGUAGES "{american,MASTERDICTS=american.med,HASHFILES=americanmed.hash}"
    #define MASTERHASH "americanmed.hash"
    #define BINDIR "$out/bin"
    #define LIBDIR "$out/lib"
    #define ELISPDIR "{$out}/share/emacs/site-lisp"
    #define TEXINFODIR "$out/share/info"
    #define MAN1DIR "$out/share/man/man1"
    #define MAN4DIR "$out/share/man/man4"
    #define MAN45DIR "$out/share/man/man5"
    #define MINIMENU
    #define HAS_RENAME
    EOF

    #XXX: We need USG for term.c, but we don't need bcopy/bzero
    #sed -i -e "s|#define bzero.*||" -e "s|#define bcopy.*||" config.X

    #XXX: getline is already defined (name clash), so rename it
    #sed -i -e "s|getline|getlineXXX|g" correct.c

    #XXX: strcmp is a macro, so importing it as function won't work
    #sed -i -e 's| *extern int\s*strcmp.*||' ijoin.c

    #XXX: buildhash uses int to store pointers, which doesn't work on 64bit
    #sed -i -e 's|\s*int\s*strptr|intptr_t strptr|' -e 's|\s*int\s*x|intptr_t x|' buildhash.c
  '';
  preBuild = ''
    for dir in $out/share/emacs/site-lisp $out/share/info $out/share/man/man1 $out/share/man/man4 $out/bin $out/lib; do
    mkdir -p $dir
    done
  '';
}