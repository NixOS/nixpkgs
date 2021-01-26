{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-outline";
  version = "unstable-2018-11-22";
  rev = "7182a932836a71948db4a81991a494751eccfe77";

  goPackagePath = "github.com/ramya-rao-a/go-outline";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "ramya-rao-a";
    repo = "go-outline";
    sha256 = "0p381yvwvff0i4i7mf5v1k2q1lb0rs2xkjgv67n1cw2573c613r1";
  };

  meta = {
    description = "Utility to extract JSON representation of declarations from a Go source file";
    homepage = "https://github.com/ramya-rao-a/go-outline";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.mit;
  };
}
