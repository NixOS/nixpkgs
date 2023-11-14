{ lib, buildGoModule, fetchFromGitHub, testers, pb }:

buildGoModule rec {
  pname = "pb";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZtjlrWCL1h2qtpLsr7HN6ZcYhybjnoSFwMAXFGCn00A=";
  };

  vendorHash = "sha256-dNSr0bQz7XdC2fTD82TI8tfmwKBuAcbxjaMC9KAjxlI=";

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
    license = licenses.agpl3;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "pb";
  };
}
