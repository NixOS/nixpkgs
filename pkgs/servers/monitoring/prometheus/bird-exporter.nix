{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bird-exporter";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "bird_exporter";
    rev = version;
    sha256 = "sha256-N/00+2OrP0BsEazD9bHk+w/xO9E6sFT6nC0MM4n9lR4=";
  };

  vendorSha256 = "sha256-9xKMwHNgPMtC+J3mwwUNSJnpMGttpaWF6l8gv0YtvHE=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bird; };

  meta = with lib; {
    description = "Prometheus exporter for the bird routing daemon";
    homepage = "https://github.com/czerwonk/bird_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
  };
}
