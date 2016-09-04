{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pmccabe-2.4-CVS20070814";

  src = fetchurl {
    url = "http://cvs.parisc-linux.org/download/${name}.tar.gz";
    sha256 = "0nqvfdf2cxx516nw0rwr3lhzhiyrnpc2jf45ldfwsdc9rm2nj3r9";
  };

  configurePhase = ''
    sed -i "Makefile"							\
        -"es|^[[:blank:]]*DESTDIR[[:blank:]]*=.*$|DESTDIR = $out|g ;	\
	   s|^[[:blank:]]*INSTALL[[:blank:]]*=.*$|INSTALL = install|g ;	\
	   s|/usr/|/|g"
  '';

  meta = {
    description = "McCabe-style function complexity and line counting for C and C++";
    homepage = http://www.parisc-linux.org/~bame/pmccabe/;
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      pmccabe calculates McCabe-style cyclomatic complexity for C and
      C++ source code.  Per-function complexity may be used for
      spotting likely trouble spots and for estimating testing
      effort.

      pmccabe also includes a non-commented line counter, decomment which
      only removes comments from source code; codechanges, a program to
      calculate the amount of change which has occurred between two source
      trees or files; and vifn, to invoke vi given a function name rather
      than a file name.
    '';
    platforms = stdenv.lib.platforms.linux;
  };
}
