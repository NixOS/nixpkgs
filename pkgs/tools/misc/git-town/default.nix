{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-town";
  version = "7.3.0";

  goPackagePath = "github.com/Originate/git-town";

  src = fetchFromGitHub {
    owner = "Originate";
    repo = "git-town";
    rev = "v${version}";
    sha256 = "166g9i79hqga8k5wvs0b84q6rqniizzsd39v37s9w16axgdrm6nb";
  };

  buildFlagsArray = [ "-ldflags=-X github.com/Originate/git-town/src/cmd.version=v${version} -X github.com/Originate/git-town/src/cmd.buildDate=nix" ];

  meta = with stdenv.lib; {
    description = "Generic, high-level git support for git-flow workflows";
    homepage = "http://www.git-town.com/";
    maintainers = [ maintainers.allonsy ];
    license = licenses.mit;
  };
}

