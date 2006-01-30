{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "rss-glx-0.8.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/rss-glx_0.8.0.tar.bz2;
    md5 = "d04e909521626a27f9f6d9b5f8a24d6c";
  };

  buildInputs = [x11 mesa];
  inherit mesa;
  
  mesaSwitch = ../../../build-support/opengl/mesa-switch.sh;
}
