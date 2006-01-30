{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "core-apache-ant-1.6.5";
  realname = "apache-ant-1.6.5";

  builder = ./core-builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/apache-ant-1.6.5-bin.tar.bz2;
    md5 = "26031ee1a2fd248ad0cc2e7f17c44c39";
  };
}
