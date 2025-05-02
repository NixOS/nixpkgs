{ lib, buildGoModule, fetchFromGitHub, testers, pb }:

buildGoModule rec {
  pname = "pb";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ckRvtEtagyYpXJ0hh8jsgpE/16bu7b9IdNn2stvb2iI=";
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
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "pb";
  };
}
