{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-town";
  version = "7.7.0";

  goPackagePath = "github.com/git-town/git-town";
  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    rev = "v${version}";
    sha256 = "sha256-FpBEBx2gb33fGDndvZmvG1A61NoJ4Qy4V3YQSb+Ugsc=";
  };

  ldflags = [ "-X github.com/git-town/git-town/src/cmd.version=v${version}" "-X github.com/git-town/git-town/src/cmd.buildDate=nix" ];

  meta = with lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    maintainers = [ maintainers.allonsy maintainers.blaggacao ];
    license = licenses.mit;
  };
}
