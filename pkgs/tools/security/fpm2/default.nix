{ lib, stdenv, fetchurl, pkg-config, gnupg, gtk2
, libxml2, intltool
}:

with lib;

stdenv.mkDerivation rec {
  pname = "fpm2";
  version = "0.79";

  src = fetchurl {
    url = "https://als.regnet.cz/fpm2/download/fpm2-${version}.tar.bz2";
    sha256 = "d55e9ce6be38a44fc1053d82db2d117cf3991a51898bd86d7913bae769f04da7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gnupg gtk2 libxml2 intltool ];

  meta = {
    description = "GTK2 port from Figaro's Password Manager originally developed by John Conneely, with some new enhancements";
    homepage    = "https://als.regnet.cz/fpm2/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ hce ];
  };
}
