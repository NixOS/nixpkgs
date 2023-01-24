{ lib, stdenv, fetchurl, bison, ncurses }:

stdenv.mkDerivation rec {
  pname = "ispell";
  version = "3.4.05";

  src = fetchurl {
    url = "https://www.cs.hmc.edu/~geoff/tars/${pname}-${version}.tar.gz";
    sha256 = "sha256-zwxt7eP9JfraQ3XYasr+WDy5bY/lRt50apLrtt+JVgI=";
  };

  buildInputs = [ bison ncurses ];

  postPatch = ''
    cat >> local.h <<EOF
    ${lib.optionalString (!stdenv.isDarwin) "#define USG"}
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
  '';

  meta = with lib; {
    description = "An interactive spell-checking program for Unix";
    homepage = "https://www.cs.hmc.edu/~geoff/ispell.html";
    license = licenses.free;
    platforms = platforms.unix;
  };
}
