{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-5haMQlwGJO0WdT75AEfs41k1oWUqrFk9nj+DOcKAom0=";
  };

  vendorHash = "sha256-qHs6KuBmJmmkmR23Ae7COadb2F7N8CMUmScx8JFt98Q=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    mainProgram = "junos_exporter";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
