{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "getopt-1.1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/getopt-1.1.4.tar.gz;
    md5 = "02188ca68da27c4175d6e9f3da732101";
  };
}
