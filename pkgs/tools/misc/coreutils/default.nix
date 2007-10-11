{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coreutils-6.9";
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-6.9.tar.bz2;
    sha256 = "1c4p2kiy4m024qcl1przvphy8vhivf8jvclq6bjm1pjps5d8khl9";
  };
  patches = [ ./gnulib-futimens.patch ] ;
}
