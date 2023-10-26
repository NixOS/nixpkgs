{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-99U6z7ncUSu49ozPU2Fc1jDxZyn5C2fE7EeTwGF76WQ=";
  };

  vendorHash = "sha256-T9dwNDbse59abetKx0wXuzFSXTx+5CaMpf0H9/Z40kE=";

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
