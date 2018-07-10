{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kail-${version}";
  version = "0.6.0";

  goPackagePath = "github.com/boz/kail";

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "17ybcncdjssil4bn3n2jp1asfcpl8vj560afb2mry9032qrryvx9";
  };

  # regenerate deps.nix using following steps:
  #
  # go get -u github.com/boz/kail
  # cd $GOPATH/src/github.com/boz/kail
  # git checkout <version>
  # dep init
  # dep2nix
  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Kubernetes log viewer";
    homepage = https://github.com/boz/kail;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
