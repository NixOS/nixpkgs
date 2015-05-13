{ stdenv, goPackages, fetchFromGitHub, callPackage }:

with goPackages;

buildGoPackage rec {
  rev = "eb2e83c1df892d2c9ad5a3c85672da30be585dfd";
  name = "goconvey-${stdenv.lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/smartystreets/goconvey";
  src = fetchFromGitHub {
    inherit rev;
    owner = "smartystreets";
    repo = "goconvey";
    sha256 = "1mmdh2wwf28a9l45jqqzgp8hnll7pfwc8jfdjnw47855km0ls407";
  };
  propagatedBuildInputs = [ gls assertions ];
  subPackages = [ "convey/gotest" ];
  doCheck = false;
}
