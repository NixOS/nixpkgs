{stdenv, fetchurl, apacheAnt, jdk, unzip}:

stdenv.mkDerivation {

  name = "axis2-1.4";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.hippo.nl/ws/axis2/1_4/axis2-1.4-bin.zip;
    md5 = "5fa104137aec522675aeaa2e6414dc40";
  };

  inherit apacheAnt jdk unzip;
}
