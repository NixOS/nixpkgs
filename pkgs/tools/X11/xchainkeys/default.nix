{ stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  name = "xchainkeys-0.11";

  src = fetchurl {
    url = "http://henning-bekel.de/download/xchainkeys/${name}.tar.gz";
    sha256 = "1rpqs7h5krral08vqxwb0imy33z17v5llvrg5hy8hkl2ap7ya0mn";
  };

  buildInputs = [ libX11 ];

  meta = {
    homepage = http://henning-bekel.de/xchainkeys/;
    description = "A standalone X11 program to create chained key bindings";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
