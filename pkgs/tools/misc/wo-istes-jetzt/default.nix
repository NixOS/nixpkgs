{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wo-istes-jetzt-${version}";
  version = "2.0.0";
  rev = "v${version}";

  goPackagePath = "github.com/elseym/wo.istes.jetzt";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "elseym";
    repo = "wo.istes.jetzt";
    sha256 = "16b61y90i00yhhg6jhc3qnz88xr65lsqjbd8s5lvw0h815lpq72p";
  };
}
