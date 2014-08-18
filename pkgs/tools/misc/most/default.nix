{ stdenv, fetchurl, slang, ncurses }:

stdenv.mkDerivation {
  name = "most-5.0.0";

  src = fetchurl {
    url = ftp://space.mit.edu/pub/davis/most/most-5.0.0.tar.bz2;
    sha256 = "1f5x7rvjg89b5klfqs1gb91jmbnd3fy08d8rwgdvgg0plqkxr7ja";
  };

  preConfigure = ''
    sed -i -e "s|-ltermcap|-lncurses|" configure
    sed -i autoconf/Makefile.in src/Makefile.in \
      -e "s|/bin/cp|cp|"  \
      -e "s|/bin/rm|rm|"
  '';
  
  configureFlags = "--with-slang=${slang}";

  buildInputs = [ slang ncurses ];

  meta = {
    description = ''
      MOST is a powerful paging program for Unix, VMS, MSDOS, and win32
      systems. Unlike other well-known paging programs most supports multiple
      windows and can scroll left and right. Why settle for less?
    '';
    homepage = http://www.jedsoft.org/most/index.html;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.gnu; # random choice
  };
}
