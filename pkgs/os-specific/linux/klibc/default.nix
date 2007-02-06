{stdenv, fetchurl, perl, bison, mktemp, kernel}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "klibc-1.4.33";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/libs/klibc/Testing/klibc-1.4.33.tar.bz2;
    sha256 = "1831bphb4z1x8vkhqmvxkb617pb4dixq33bm0nc6qrxrwix0ylag";
  };
  inherit kernel;
  buildInputs = [perl bison mktemp];
  patches = [./install.patch];
}
