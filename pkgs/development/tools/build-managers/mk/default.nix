{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "mk";
  version = "unstable-2006-01-31";
  src = fetchurl {
    url = "http://tarballs.nixos.org/${pname}-20060131.tar.gz";
    sha256 = "0za8dp1211bdp4584xb59liqpww7w1ql0cmlv34p9y928nibcxsr";
  };
  builder = ./builder.sh;

  meta = {
    platforms = lib.platforms.unix;
  };
}
