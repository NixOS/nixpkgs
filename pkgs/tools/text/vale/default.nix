{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "1.0.3";
  rev    = "v${version}";

  goPackagePath = "github.com/errata-ai/vale";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "errata-ai";
    repo   = "vale";
    sha256 = "132zzgry19alcdn3m3q62sp2lm3yxc4kil12lm309jl7b3n0850h";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://errata.ai/vale/getting-started/;
    description = "Vale is an open source linter for prose";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
