{ lib, buildGoModule, fetchFromGitHub, testers, pb }:

buildGoModule rec {
  pname = "pb";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MCWDCFW37OTy6Hd9pVem+gwKGdZ7htIXFbdUciqAjU8=";
  };

  vendorHash = "sha256-WDBjAAaeKeMJOwX8w9PLq9Y8IX2o5yzH2o+MNFSgYc4=";

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
