{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apache-ant-1.6.1";
  builder = ./core-builder.sh;
  src = fetchurl {
    url = http://www.apache.org/dist/ant/binaries/apache-ant-1.6.1-bin.tar.bz2;
    md5 = "703d0265d05b98afd95be0bc21b98420";
  };
}
