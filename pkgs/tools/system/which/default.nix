{stdenv, fetchurl, readline}: stdenv.mkDerivation {
  name = "which-2.19";
  src = fetchurl {
    url = mirror://gnu/pub/gnu/which/which-2.19.tar.gz;
    sha256 = "0lnd8mfpc0r1r2ch54vl3vc6r0fnzfl33sqdda2aq62iyrsbhybx";
  };

  buildInputs = [readline];
}



