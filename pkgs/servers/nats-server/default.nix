{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OYfyLY15v6P5srliEM7kTfa1pKFh3RR6zMWrKH2h7d4=";
  };

  vendorSha256 = "sha256-wqS9EwjcsJgdAurwxmZBgjbLKpMQEOaQkReuu0VlnGc=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
