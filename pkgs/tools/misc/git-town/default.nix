{ stdenv, buildGoPackage, fetchFromGitHub }: 

  buildGoPackage rec {
    name = "git-town-${version}";
    version = "7.2.0";

    goPackagePath = "github.com/Originate/git-town";

    src = fetchFromGitHub {
      owner = "Originate";
      repo = "git-town";
      rev = "v${version}";
      sha256 = "0hr0c6iya34lanfhsg9kj03l4ajalcfxkbn4bgwh0749smhi6mrj";
    };

    buildFlagsArray = [ "-ldflags=-X github.com/Originate/git-town/src/cmd.version=v${version} -X github.com/Originate/git-town/src/cmd.buildDate=nix" ];

    meta = with stdenv.lib; {
      description = "Generic, high-level git support for git-flow workflows";
      homepage = http://www.git-town.com/;
      maintainers = [ maintainers.allonsy ];
      license = licenses.mit;
    };
  }

