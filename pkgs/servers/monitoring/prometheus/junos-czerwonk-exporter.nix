{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-mYhe4EYbvSXi08/sUrsk0G9zx6LjScXBr0cDecr1cQo=";
  };

  vendorHash = "sha256-MXKebWivVU/AP/YlCGM7a28AVJSPk10OFcdkYthf0G0=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    teams = [ teams.wdz ];
  };
}
