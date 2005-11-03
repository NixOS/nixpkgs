{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.16.1-arm";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.nluug.nl/gnu/binutils/binutils-2.16.1.tar.bz2;
    md5 = "6a9d529efb285071dad10e1f3d2b2967";
  };
  inherit noSysDirs;
  configureFlags = "--target=arm-linux";
}
