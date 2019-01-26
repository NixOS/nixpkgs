{ stdenv, fetchurl, perl, pkgconfig, gtk2 }:

stdenv.mkDerivation {
  name = "eboard-1.1.1";

  src = fetchurl {
    url = mirror://sourceforge/eboard/eboard-1.1.1.tar.bz2;
    sha256 = "0vm25j1s2zg1lipwjv9qrcm877ikfmk1yh34i8f5l3bwd63115xd";
  };

  patches = [ ./eboard.patch ];

  buildInputs = [ gtk2 ];
  nativeBuildInputs = [ perl pkgconfig ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];

  NIX_LDFLAGS = [
    "-ldl"
  ];

  meta = {
    homepage = http://www.bergo.eng.br/eboard/;
    description = "Chess interface for Unix-like systems";
    platforms = stdenv.lib.platforms.linux;
  };
}
