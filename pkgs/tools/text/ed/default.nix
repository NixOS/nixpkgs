{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "ed-0.9";
  src = fetchurl {
    url = mirror://gnu/ed/ed-0.9.tar.bz2;
    sha256 = "1xy746g7ai9gmv6iq2x1ll8x6wy4fi9anfh7gj5ifsdnaiahgyi2";
  };
}
