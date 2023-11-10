{ lib, buildGoModule, fetchFromGitHub, testers, pb }:

buildGoModule rec {
  pname = "pb";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jnMGBwwsQJnbvTTLxhpwORQ5m8xZxLA0PQVhW/MjMto=";
  };

  vendorHash = "sha256-jC3P0b8fLZbL1hyWTnA/w3Uk4uqWSxpWDs6nQv55/0c=";

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
