{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-m8CveakbnxIjqFW1VwSD/sDhpf12mbZRJdwTOLaBYmc=";
  };

  vendorHash = "sha256-zD5QkpyeqrmX0zGgdQg9yQQrX/+0Xz+Q04IzpO+Qc5Q=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    teams = [ teams.wdz ];
  };
}
