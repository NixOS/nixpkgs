{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mk-2006-01-31";
  src = fetchurl {
    url = "http://tarballs.nixos.org/mk-20060131.tar.gz";
    sha256 = "0za8dp1211bdp4584xb59liqpww7w1ql0cmlv34p9y928nibcxsr";
  };
  builder = ./builder.sh;

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
