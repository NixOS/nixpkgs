{ stdenv, lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "librarian-puppet-go-${version}";
  version = "0.3.9";

  goPackagePath = "github.com/tmtk75/librarian-puppet-go";

  src = fetchFromGitHub {
    owner = "tmtk75";
    repo = "librarian-puppet-go";
    rev = "v${version}";
    sha256 = "19x2hz3b8xkhy2nkyjg6s4qvs55mh84fvjwp157a86dmxwkdf45y";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "librarian-puppet implementation in go.";
    license = licenses.unfree; # still unspecified https://github.com/tmtk75/librarian-puppet-go/issues/5
    maintainers = with maintainers; [ womfoo ];
    platforms = [ "x86_64-linux" ];
  };
}
