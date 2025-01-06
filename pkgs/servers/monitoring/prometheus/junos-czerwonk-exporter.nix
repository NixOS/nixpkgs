{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-a9DvmVgIXiM4DjTg2BmdPbJCpFmyD+ZoUc5VPEEFVp8=";
  };

  vendorHash = "sha256-DjNxXvMliM7MPv9gAOblnA5CkVcrXLlpaR8NOiZ65yc=";

  meta = {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = lib.licenses.mit;
    maintainers = lib.teams.wdz.members;
  };
}
