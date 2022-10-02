{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FifLZ6kQgNMyL+0Axc7lqvCk3eHc8pxKpm045jboSoQ=";
  };

  vendorSha256 = "sha256-yVTAgG3j2zrPEFGAcV4LSihws9XUoYrZ81fp/MYv8Eo=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
