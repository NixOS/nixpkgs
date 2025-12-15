{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-RCh81CHdFjJ6R/3wMons4v/xO+kvNa9ohnlWVGSkiyU=";
  };

  vendorHash = "sha256-zD5QkpyeqrmX0zGgdQg9yQQrX/+0Xz+Q04IzpO+Qc5Q=";

  meta = {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = lib.licenses.mit;
    teams = [ lib.teams.wdz ];
  };
}
