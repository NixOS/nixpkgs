{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "slurm-exporter";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "rovanion";
    repo = "prometheus-slurm-exporter";
    rev = version;
    sha256 = "052g9q4ma0dsggxb3pajl9ml4293xfv10ani0qlrzh20n22j5kva";
  };

  vendorSha256 = "sha256:0g3wmb5i0d97yv98921apw5w4vgd5w9zqlqvsq918v136bpyzf9y";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) slurm; };

  checkPhase = ''
    make unittest
  '';

  meta = with lib; {
    description = "A Prometheus stats exporter for the Slurm cluster manager. ";
    homepage = "https://github.com/rovanion/prometheus-slurm-exporter";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rovanion ];
  };
}
