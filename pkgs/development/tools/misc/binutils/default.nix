{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.15";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/binutils/binutils-2.15.tar.bz2;
    md5 = "624e6b74983ac6b2960edaf2d522ca58";
  };
  patches = [./no-lex.patch];
  inherit noSysDirs;
}
