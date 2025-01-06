{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-H7EaNQmgrRomIQo2xm2Qqkud0LMSYFshNv54lRdrEyw=";
  };

  vendorHash = "sha256-k/n9muWFtTBv8PxMdevFBeTtAOIiCDrK3GoCGeMtBn4=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    maintainers = lib.teams.deshaw.members;
    mainProgram = "fastly-exporter";
  };
}
