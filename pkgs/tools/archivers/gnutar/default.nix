{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.16.1";
  src = fetchurl {
    url = mirror://gnu/tar/tar-1.16.1.tar.bz2;
    md5 = "d51593461c5ef1f7e37134f22338bb9e";
  };
  patches = [./implausible.patch ./gnulib-futimens.patch];
}
