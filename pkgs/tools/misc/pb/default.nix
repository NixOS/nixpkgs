{ lib, buildGoModule, fetchFromGitHub, testers, pb }:

buildGoModule rec {
  pname = "pb";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ub4/ou0FprDPTdGarehUPVPov2kLl6SbIlhpPiEarE8=";
  };

  vendorHash = "sha256-38lXffh3ZkMtvHi9roLHW0A6bzb+LRC91I3DdYyq1h0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [ "kqueue" ];

  passthru.tests.version = testers.testVersion {
    package = pb;
    command = "pb version";
  };

  meta = with lib; {
    homepage = "https://github.com/parseablehq/pb";
    changelog = "https://github.com/parseablehq/pb/releases/tag/v${version}";
    description = "CLI client for Parseable server";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "pb";
  };
}
