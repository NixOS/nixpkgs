{ lib, stdenv, fetchurl, slang, ncurses }:

stdenv.mkDerivation rec {
  pname = "most";
  version = "5.2.0";

  src = fetchurl {
    url = "https://www.jedsoft.org/releases/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-lFWuuPgm+oOFyFDcIr8PIs+QabPDQj+6S/LG9iJtmQM=";
  };

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
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "most";
  };
}
