{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "junos-czerwonk-exporter";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "junos_exporter";
    rev = version;
    sha256 = "sha256-9Oh1GsqoIml/SKCmLHuJSnz0k2szEYkb6ArEsU5p198=";
  };

  vendorHash = "sha256-cQChRpjhL3plUk/J+8z2cg3u9IhMo6aTAbY8M/qlXSQ=";

  meta = with lib; {
    description = "Exporter for metrics from devices running JunOS";
    homepage = "https://github.com/czerwonk/junos_exporter";
    license = licenses.mit;
    maintainers = teams.wdz.members;
  };
}
