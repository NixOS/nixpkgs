{stdenv, fetchurl, bison, flex, db4}:

stdenv.mkDerivation {
  name = "iproute2-2.6.15-060110";
  src = fetchurl {
    url = http://developer.osdl.org/dev/iproute2/download/iproute2-2.6.15-060110.tar.gz;
    md5 = "04f57a6d366d36426d276178b600f5c5";
  };
  buildInputs = [bison flex db4];
  patches = [./iproute2-2.6.15-060110-path.patch];

}
