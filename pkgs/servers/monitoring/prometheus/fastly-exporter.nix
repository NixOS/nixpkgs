{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-Iu+GqCE7Eg2oN6vmdpgsPKHqxz91f12waxj0J2K+gWk=";
  };

  vendorHash = "sha256-83qUoQNiQ3D2Bm6D4DoVZDEO8EtUmxBXlpV6F+N1eSA=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    teams = [ lib.teams.deshaw ];
    mainProgram = "fastly-exporter";
  };
}
