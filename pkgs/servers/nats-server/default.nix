{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.17";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JX5uV4273BzO0tmdagEDlJ8eyaFBlpdOS6F1rz9IrF4=";
  };

  vendorHash = "sha256-JAj4lF/5cy9SDFb0X08d2kFUVwdUJ53EYeEOlJ71z2k=";

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
