{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-KdVyRddAr2gqiFyIGBfWbi4DHAaiey4p4OBFND/2u7U=";
  };

  vendorHash = "sha256-fytDr56ZhhO5u6u9CRIEKXGqgnzntSVqEVItibpLyPM=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
