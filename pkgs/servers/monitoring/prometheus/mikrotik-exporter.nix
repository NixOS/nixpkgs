{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "mikrotik-exporter-unstable";
  version = "2021-08-10";

  src = fetchFromGitHub {
    owner = "nshttpd";
    repo = "mikrotik-exporter";
    sha256 = "1vqn1f159g0l76021gifbxpjf7zjhrj807qqqn51h5413lbi6r66";
    rev = "4bfa7adfef500ff621a677adfab1f7010af920d1";
  };

  vendorSha256 = "0b244z3hly5726vwkr7vhdzzm2fi38cv1qh7nvfp3vpsxnii04md";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) mikrotik; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Prometheus MikroTik device(s) exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmilata ];
  };
}
