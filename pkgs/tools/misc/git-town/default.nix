{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-town";
  version = "7.4.0";

  goPackagePath = "github.com/git-town/git-town";
  src = fetchFromGitHub {
    owner = "git-town";
    repo = "git-town";
    rev = "v${version}";
    sha256 = "05s2hp4xn0bs3y6rgqkpgz0k8q8yfpwkw5m8vwim95hk6n41ps18";
  };

  buildFlagsArray = [ "-ldflags=-X github.com/git-town/git-town/src/cmd.version=v${version} -X github.com/git-town/git-town/src/cmd.buildDate=nix" ];

  meta = with stdenv.lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "https://www.git-town.com/";
    maintainers = [ maintainers.allonsy maintainers.blaggacao ];
    license = licenses.mit;
  };
}

