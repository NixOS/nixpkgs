{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname   = "nats-server";
  version = "2.7.3";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-8XCk447Ow+lPo7cTSWQFytsoi0XQZygi+8H0RRtA1bA=";
  };

  vendorSha256 = "sha256-ES56ARMAOLQPqc8/xeqB0cpPFq1fb1ShLXbSeVX9yXs=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
    homepage = "https://nats.io/";
  };
}
