{ lib, stdenv, fetchurl, pkg-config, libxml2, gtk3-x11, libXt, libXpm }:

stdenv.mkDerivation rec {
  pname = "xsnow";
  version = "3.3.6";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "sha256-rTJO1btS1VBHatj9Yr2R6vZBUPQtCB1Aa6AD6IzwuLg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3-x11 libxml2 libXt libXpm ];

  makeFlags = [ "gamesdir=$(out)/bin" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An X-windows application that will let it snow on the root, in between and on windows";
    homepage = "https://ratrabbit.nl/ratrabbit/xsnow/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ robberer ];
    platforms = platforms.unix;
  };
}
