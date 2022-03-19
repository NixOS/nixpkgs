{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname   = "nats-server";
  version = "2.7.4";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-lMwFh+njzQr1hOJFbO3LnPdBK7U4XmX4F/6MlIRILlU=";
  };

  vendorSha256 = "sha256-EEOvDOqMbqfB0S3Nf7RQMKGSZX802eqa3eGaNjUHxQ4=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
    homepage = "https://nats.io/";
  };
}
