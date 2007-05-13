{stdenv, fetchurl, e2fsprogs, readline}:

stdenv.mkDerivation {
  name = "parted-1.8.7";
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/parted/parted-1.8.7.tar.bz2;
    sha256 = "0njabfinn1kbkdx80gayqanpammnl28pklli34bymhx1sxn82kk3";
  };
  buildInputs = [e2fsprogs readline];

  configureFlags = "--without-readline";
}
