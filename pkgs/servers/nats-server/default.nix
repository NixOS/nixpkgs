{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname   = "nats-server";
  version = "2.7.2";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "0w4hjz1x6zwcxhnd1y3874agyn8nsdra4fky6kc2rrfikjcw003y";
  };

  vendorSha256 = "1gvvjwx1g8mhcqi3ssb3k5ylkz0afpmnf6h2zfny9rc4dk2cp2dy";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
    homepage = "https://nats.io/";
  };
}
