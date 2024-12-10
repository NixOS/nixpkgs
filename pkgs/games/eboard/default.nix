{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "eboard";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/eboard/eboard-${version}.tar.bz2";
    sha256 = "0vm25j1s2zg1lipwjv9qrcm877ikfmk1yh34i8f5l3bwd63115xd";
  };

  patches = [ ./eboard.patch ];

  buildInputs = [ gtk2 ];
  nativeBuildInputs = [
    perl
    pkg-config
  ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  meta = {
    homepage = "http://www.bergo.eng.br/eboard/";
    description = "Chess interface for Unix-like systems";
    platforms = lib.platforms.linux;
  };
}
