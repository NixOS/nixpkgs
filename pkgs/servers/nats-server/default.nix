{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.17";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tWCZq6OwcjVaeaL4CrxSPwGaCKNZ2eN5s3vOoU9oT1I=";
  };

  vendorHash = "sha256-Qn1FkZLo3EC7KX7ZsQLDu26fbMFiwvy7cjlsFlgMtmo=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
