{ lib, stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fnykdk35937ld8dyzjs571klz187jr8wlj8ljn78pajx1cd84k6";
  };

  vendorSha256 = "19qx7ab6ar609cxxdsb9i2c3h7icqgf5bhi28lnsdk3bdjxr27vz";

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
