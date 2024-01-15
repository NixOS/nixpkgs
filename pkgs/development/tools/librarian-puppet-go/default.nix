{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "librarian-puppet-go";
  version = "0.3.10";

  goPackagePath = "github.com/tmtk75/librarian-puppet-go";

  src = fetchFromGitHub {
    owner = "tmtk75";
    repo = "librarian-puppet-go";
    rev = "v${version}";
    sha256 = "sha256-IEhqyowyLTXDEhg4nkix1N45S0+k+RngMP6TsaZQ4mI=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "librarian-puppet implementation in go";
    license = licenses.mit;
    maintainers = with maintainers; [ womfoo ];
    platforms = [ "x86_64-linux" ];
  };
}
