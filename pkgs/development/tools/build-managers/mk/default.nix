{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mk-2006-01-31";
  src = fetchurl {
    url = http://tarballs.nixos.org/mk-20060131.tar.gz;
    md5 = "167fd4e0eea4f49def01984ec203289b";
  };
  builder = ./builder.sh;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
