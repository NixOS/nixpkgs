{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "objconv-1.0";

  src = fetchFromGitHub {
    owner  = "vertis";
    repo   = "objconv";
    rev    = "01da9219e684360fd04011599805ee3e699bae96";
    sha256 = "1by2bbrampwv0qy8vn4hhs49rykczyj7q8g373ym38da3c95bym2";
  };

  buildPhase = "c++ -o objconv -O2 src/*.cpp";

  installPhase = "mkdir -p $out/bin && mv objconv $out/bin";
}
