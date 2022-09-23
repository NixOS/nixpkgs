{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nats-server";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zKDaem388xngSbpF1cK/hffLWMlrROJ00OBBSjzeMqk=";
  };

  vendorSha256 = "sha256-p+UMKVHDm6ypr1ftwb6L/kPocUrSp05un71T1WlLWbA=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    homepage = "https://nats.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
