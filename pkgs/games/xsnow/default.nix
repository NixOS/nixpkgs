{ lib, stdenv, fetchurl, pkg-config, libxml2, gtk3-x11, libXt, libXpm }:

stdenv.mkDerivation rec {
  pname = "xsnow";
  version = "3.3.0";

  src = fetchurl {
    url = "https://ratrabbit.nl/downloads/xsnow/xsnow-${version}.tar.gz";
    sha256 = "1xnpqbamhglv7xsxzlrlpvsz6bbzlrvdpn5x2n9baww9kcrkbwjg";
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
