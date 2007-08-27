{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.8";
  src = fetchurl {
    url = mirror://gnu/ed/ed-0.8.tar.bz2;
    sha256 = "07zaw9w6vrcvpc2srd0zkm7948j262zx2xwj5qbb3lhvry3kr61p";
  };
}
