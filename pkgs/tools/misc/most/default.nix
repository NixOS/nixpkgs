{ lib, stdenv, fetchurl, slang, ncurses }:

stdenv.mkDerivation rec {
  pname = "most";
  version = "5.1.0";

  src = fetchurl {
    url = "https://www.jedsoft.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "008537ns659pw2aag15imwjrxj73j26aqq90h285is6kz8gmv06v";
  };

  patches = [
    # Upstream patch to fix parallel build failure
    ./parallel-make.patch
  ];

  outputs = [ "out" "doc" ];

  makeFlags = [
    "DOC_DIR=${placeholder "doc"}/share/doc/most"
  ];

  preConfigure = ''
    sed -i -e "s|-ltermcap|-lncurses|" configure
    sed -i autoconf/Makefile.in src/Makefile.in \
      -e "s|/bin/cp|cp|"  \
      -e "s|/bin/rm|rm|"
  '';

  configureFlags = [ "--with-slang=${slang.dev}" ];

  buildInputs = [ slang ncurses ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A terminal pager similar to 'more' and 'less'";
    longDescription = ''
      MOST is a powerful paging program for Unix, VMS, MSDOS, and win32
      systems. Unlike other well-known paging programs most supports multiple
      windows and can scroll left and right. Why settle for less?
    '';
    homepage = "https://www.jedsoft.org/most/index.html";
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "most";
  };
}
