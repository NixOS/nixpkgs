{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "core-apache-ant-1.6.2";
  realname = "apache-ant-1.6.2";

  builder = ./core-builder.sh;
  src = fetchurl {
    url = http://www.apache.org/dist/ant/binaries/apache-ant-1.6.2-bin.tar.bz2 ;
    md5 = "a568c7271c3f168771c0313926d060fa";
  };
}
