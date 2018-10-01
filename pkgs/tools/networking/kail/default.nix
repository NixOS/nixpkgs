{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kail-${version}";
  version = "0.7.0";

  goPackagePath = "github.com/boz/kail";

  src = fetchFromGitHub {
    owner = "boz";
    repo = "kail";
    rev = "v${version}";
    sha256 = "0j0948wjn0jsk89fp0l29pd90n86wi85yghrbdhwihhgyqcdmhi0";
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
    maintainers = with maintainers; [ offline vdemeester ];
  };
}
