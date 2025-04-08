{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-PZKP8kcxU5ArC+bkYIO91Dg/f85T5qneX4wuKTj/jP4=";
  };

  vendorHash = "sha256-C2PvbvWJC6EGEKtg/roaG63YFdW9/ZYHulUdwC/2/MY=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
