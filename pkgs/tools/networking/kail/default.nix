{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kail";
  version = "0.8.0";

  goPackagePath = "github.com/boz/kail";

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "0ibk7j40pj6f2086qcnwp998wld61d2gvrv7yiy6hlkalhww2pq7";
  };

  # regenerate deps.nix using following steps:
  #
  # go get -u github.com/boz/kail
  # cd $GOPATH/src/github.com/boz/kail
  # git checkout <version>
  # dep init
  # dep2nix
  deleteVendor = true;
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Kubernetes log viewer";
    homepage = "https://github.com/boz/kail";
    license = licenses.mit;
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
