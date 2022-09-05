{ stdenv, lib, fetchurl, ncurses }:
stdenv.mkDerivation rec {
  pname = "xstow";
  version = "1.1.0";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-wXQ5XSmogAt1torfarrqIU4nBYj69MGM/HBYqeIE+dw=";
  };

  buildInputs = [
    ncurses
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A replacement of GNU Stow written in C++";
    homepage = "http://xstow.sourceforge.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nzbr ];
    platforms = platforms.unix;
  };
}
