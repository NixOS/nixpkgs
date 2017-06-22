{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wo-istes-jetzt-${version}";
  version = "2.1.0";
  rev = "v${version}";

  goPackagePath = "github.com/elseym/wo.istes.jetzt";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "elseym";
    repo = "wo.istes.jetzt";
    sha256 = "0x6yyginzxg2d6nm12jwsygzlya68pvh97lcjmr808pwzvwmx2z7";
  };
}
