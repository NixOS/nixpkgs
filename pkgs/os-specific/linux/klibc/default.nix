{stdenv, fetchurl, perl, bison, mktemp, kernel}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "klibc-1.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://kernel/linux/libs/klibc/klibc-1.5.tar.bz2;
    sha256 = "1izhf8kscjymsvsvhcqw9awnmp94vwv70zdj09srg9bkpjj0n017";
  };
  inherit kernel;
  buildInputs = [perl bison mktemp];
  patches = [./install.patch];
}
