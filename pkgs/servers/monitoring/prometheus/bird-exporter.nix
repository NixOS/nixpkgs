{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
    sha256 = "06rlmmvr79db3lh54938yxi0ixcfb8fni0vgcv3nafqnlr2zbs58";
  };

  vendorSha256 = "14bjdfqvxvb9gs1nm0nnlib52vd0dbvjll22x7d2cc721cbd0hj0";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
