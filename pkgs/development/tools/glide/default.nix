{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "glide-${version}";
  version = "0.10.2";
  rev = "${version}";
  
  goPackagePath = "github.com/Masterminds/glide";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Masterminds";
    repo = "glide";
    sha256 = "1qb2n5i04gabb2snnwfr8wv4ypcp1pdzvgga62m9xkhk4p2w6pwl";
  };
}
