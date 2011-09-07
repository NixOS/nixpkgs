{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "CUnit-2.1-2";

  src = fetchurl {
    url = "mirror://sourceforge/cunit/${name}-src.tar.bz2";
    sha256 = "1slb2sybv886ys0qqikb8lzn0h9jcqfrv64lakdxmqbgncq5yw0z";
  };
}

