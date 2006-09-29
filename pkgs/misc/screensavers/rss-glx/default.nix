{stdenv, fetchurl, x11, mesa}:

stdenv.mkDerivation {
  name = "rss-glx-0.8.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/rss-glx/rss-glx_0.8.1.tar.bz2;
    md5 = "a2bdf0e10ee4e89c8975f313c5c0ba6f";
  };

  buildInputs = [x11 mesa];
  inherit mesa;
  
  mesaSwitch = ../../../build-support/opengl/mesa-switch.sh;
}
