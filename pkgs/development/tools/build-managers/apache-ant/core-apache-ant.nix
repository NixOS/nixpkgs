{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "core-apache-ant-1.6.4";
  realname = "apache-ant-1.6.4";

  builder = ./core-builder.sh;
  src = fetchurl {
    url = http://apache.surfnet.nl/ant/binaries/apache-ant-1.6.4-bin.tar.bz2;
    md5 = "2dd6f927cfe3cbac0970816396b7ad4e";
  };
}
