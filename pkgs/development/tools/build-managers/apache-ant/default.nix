{stdenv, fetchurl, j2sdk}: stdenv.mkDerivation {
  name = "apache-ant-1.6.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://dist.apache.easynet.nl/ant/binaries/apache-ant-1.6.0-bin.tar.bz2;
    md5 = "01989c306da53862c101d9ea4ebb1f00";
  };
}
