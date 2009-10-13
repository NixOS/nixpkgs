{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {
  name = "axis2-1.5";

  src = fetchurl {
    url = http://apache.mirror.easycolocate.nl/ws/axis2/1_5/axis2-1.5-bin.zip;
    sha256 = "0f0a471xfsjx7s3i9awhajl1kli8y8pd8aiki7cwb9n4g467rwmc";
  };

  buildInputs = [ unzip apacheAnt jdk ];
  builder = ./builder.sh;
}
