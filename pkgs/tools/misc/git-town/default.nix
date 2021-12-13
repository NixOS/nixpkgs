{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-town";
  version = "7.6.0";

  goPackagePath = "github.com/git-town/git-town";
  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    rev = "v${version}";
    sha256 = "sha256-yarJWIEIZuBcXXxltkiM7LwrEM8fveD3+JVoPGarhJQ=";
  };

  ldflags = [ "-X github.com/git-town/git-town/src/cmd.version=v${version}" "-X github.com/git-town/git-town/src/cmd.buildDate=nix" ];

  meta = with lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    maintainers = [ maintainers.allonsy maintainers.blaggacao ];
    license = licenses.mit;
  };
}
