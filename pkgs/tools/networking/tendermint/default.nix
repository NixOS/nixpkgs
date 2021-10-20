{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.34.13";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z3rbDdk68PTvJ/LPnAx8kOjCGXMfxQA0LK9GLYgaiUY=";
  };

  vendorSha256 = "sha256-bwDyis/dHKSqBFw5jFWSZip5YjBe1bq/ieg6Jg0P/TM=";

  subPackages = [ "cmd/tendermint" ];

  preBuild = ''
    makeFlagsArray+=(
      "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${src.rev}"
    )
  '';

  meta = with lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
