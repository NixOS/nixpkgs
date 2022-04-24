{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-repo-root";
  version = "unstable-2014-09-11";

  goPackagePath = "github.com/cstrahan/go-repo-root";

  src = fetchFromGitHub {
    owner = "cstrahan";
    repo = "go-repo-root";
    rev = "90041e5c7dc634651549f96814a452f4e0e680f9";
    sha256 = "sha256-5FVELoUq34KjBl1kzYpExDQFvH2PYQ+dbUOBLSe6n+Y=";
  };

  goDeps = ./deps.nix;
}
