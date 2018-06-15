{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "0.11.2";
  rev    = "v${version}";

  goPackagePath = "github.com/errata-ai/vale";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "errata-ai";
    repo   = "vale";
    sha256 = "0zs6bdwnc5fpa0skw1xhdwg6jzsc7wcb8lsfj235jc8jd2w13mvm";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Vale is an open source linter for prose";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
