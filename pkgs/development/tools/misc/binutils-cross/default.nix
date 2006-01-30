{stdenv, fetchurl, noSysDirs, cross}:

stdenv.mkDerivation {
  name = "binutils-2.16.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/binutils-2.16.1.tar.bz2;
    md5 = "6a9d529efb285071dad10e1f3d2b2967";
  };
  inherit noSysDirs;
  #configureFlags = if cross=="arm-linux" then "--target=arm-linux" else if cross=="mips-linux" then "--target=mips-linux" else if cross=="sparc-linux" then "--target=sparc-linux"; 
  inherit cross;
}
