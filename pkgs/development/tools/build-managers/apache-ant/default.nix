{stdenv, fetchurl, j2sdk}: derivation {
  name = "apache-ant-1.6.0";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://dist.apache.easynet.nl/ant/binaries/apache-ant-1.6.0-bin.tar.bz2;
    md5 = "01989c306da53862c101d9ea4ebb1f00";
  };
  stdenv = stdenv;
}
