{ lib, fetchFromGitHub, gotools, buildGoPackage }:

buildGoPackage rec {
  pname = "mtail";
  version = "3.0.0-rc4";
  goPackagePath = "github.com/google/mtail";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    sha256 = "1n7pqvid48ayn15qfpgpbsx0iqg24x08wphzpc08mlfw47gq7jg3";
  };

  buildInputs = [ gotools ];
  goDeps = ./deps.nix;
  patches = [ ./fix-gopath.patch ];
  preBuild = "go generate -x ./go/src/github.com/google/mtail/vm/";


  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
