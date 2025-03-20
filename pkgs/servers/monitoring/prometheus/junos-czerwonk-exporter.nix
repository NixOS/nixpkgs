{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-Pr4M2ReXOTSXj2sBpuHEzAB1PaYbK8MWmTdasDA+/5o=";
  };

  vendorHash = "sha256-HT0P7u9JDYlPb1afLDqOL9II1WNrq1b9Q7340EcCm0Q=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
