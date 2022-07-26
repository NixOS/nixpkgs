{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nats-server";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hybCAVgHSwby8oSO0T2ZuqAYbqtZDc/adSPMOTdeI+w=";
  };

  vendorSha256 = "sha256-sK79szerxz42Y6V6NyDAveeMOx0XFq28Tjx27JkEWW4=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
