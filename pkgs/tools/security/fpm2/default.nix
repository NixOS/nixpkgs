{ stdenv, fetchurl, pkgconfig, gnupg, gtk2
, libxml2, intltool
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "fpm2-${version}";
  version = "0.79";

  src = fetchurl {
    url = "http://als.regnet.cz/fpm2/download/fpm2-${version}.tar.bz2";
    sha256 = "d55e9ce6be38a44fc1053d82db2d117cf3991a51898bd86d7913bae769f04da7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnupg gtk2 libxml2 intltool ];

  meta = {
    description = "FPM2 is GTK2 port from Figaro's Password Manager originally developed by John Conneely, with some new enhancements.";
    homepage    = http://als.regnet.cz/fpm2/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ hce ];
  };
}
