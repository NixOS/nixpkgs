{ stdenv, fetchurl, libX11, libXext, xextproto, libICE, libSM, xproto, libpng, zlib }:

stdenv.mkDerivation rec {
  name = "lincity-${version}";
  version = "1.12.1";

  src = fetchurl {
    url = "mirror://sourceforge/lincity/${name}.tar.gz";
    sha256 = "0xmrp7vkkp1hfblb6nl3rh2651qsbcm21bnncpnma1sf40jaf8wj";
  };

  buildInputs = [
    libICE libpng libSM libX11 libXext
    xextproto zlib xproto
  ];

  meta = {
    description = "City simulation game";
  };
}
