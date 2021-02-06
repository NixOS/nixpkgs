{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.34.3";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tkIoLYfqlnyyAAgEKyQgE317uwyhc8xRTCTUXi+9r9s=";
  };

  vendorSha256 = "sha256-DviK+MkJwcv2Dhwmqra5G/fTaWxXFbUSUVnAkSHjeII=";

  doCheck = false;

  subPackages = [ "cmd/tendermint" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${src.rev}" ];

  meta = with lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
