{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {

  name = "axis2-1.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.hippo.nl/ws/axis2/1_3/axis2-1.3-bin.zip;
    md5 = "ab2bc77452288ebf80d861270734a83e";
  };

  inherit apacheAnt jdk unzip;
}
