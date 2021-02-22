{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.34.7";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nucfxQYjUKm9c1vn7c4w0Mxkf+rU1qEZ1bjzcL258MQ=";
  };

  vendorSha256 = "sha256-0Y9QDBVNYE2x3nY3loRKTCtYWXRnK7v+drRVvTMY4Dg=";

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
