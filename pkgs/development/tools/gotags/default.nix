{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gotags";
  version = "unstable-2015-08-03";

  goPackagePath = "github.com/jstemmer/gotags";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = "gotags";
    rev = "be986a34e20634775ac73e11a5b55916085c48e7";
    sha256 = "sha256-Su7AA6HCdeZai8+yRSKzlrgXvsSEgrXGot2ABRL2PBw=";
  };
}
