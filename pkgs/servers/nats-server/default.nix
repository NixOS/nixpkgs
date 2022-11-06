{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.6";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HmjtMfSajz0vtbr48xSmY9/30u96Z6zyaTnMuSocIOg=";
  };

  vendorSha256 = "sha256-ASLy0rPuCSYGyy5Pw9fj559nxO4vPPagDKAe8wM29lo=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
