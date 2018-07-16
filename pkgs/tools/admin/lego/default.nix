{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "lego-${version}";
  version = "1.0.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "xenolf";
    repo = "lego";
    sha256 = "1l9winhqwid8ac8il303qkhsn0v5h7zhlklviszfi1rjal38ipiz";
  };

  goPackagePath = "github.com/xenolf/lego";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = https://github.com/xenolf/lego;
    maintainers = with maintainers; [ andrew-d ];
  };
}
