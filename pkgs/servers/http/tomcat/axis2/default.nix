{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.6.1";

  src = fetchurl {
    url = http://apache.mirror.versatel.nl//axis/axis2/java/core/1.6.1/axis2-1.6.1-bin.zip;
    sha256 = "1a0p85qh9924dv3y7zivf62hy1jzdaxnndqh93g6lndmacfhkk64";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;
}
