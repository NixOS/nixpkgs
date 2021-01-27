{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "slurm-exporter";
  version = "0.14";

  goPackagePath = "github.com/vpenso/prometheus-slurm-exporter";

  src = fetchFromGitHub {
    rev = version;
    owner = "vpenso";
    repo = "prometheus-slurm-exporter";
    sha256 = "02d71q0pzgidn63x6hqz48kih3qw3dqlmwb09wgrcahdvjhrviqq";
  };

  goDeps = ./slurm-exporter-deps.nix;

  meta = with lib; {
    description = "A Prometheus stats exporter for the Slurm cluster manager. ";
    homepage = "https://github.com/vpenso/prometheus-slurm-exporter";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rovanion ];
    platforms = platforms.unix;
  };
}
