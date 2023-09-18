{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.22";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ednQfVG1/A8zliJ6oHXvfjIP7EtAiwdVaUSNUdKwn+g=";
  };

  vendorHash = "sha256-B5za9EcnAytmt0p6oyvXjfeRamsslh+O7n2xMHooLSk=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
