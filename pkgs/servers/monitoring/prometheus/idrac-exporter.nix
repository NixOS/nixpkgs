{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "idrac_exporter";
  version = "unstable-2023-06-29";

  src = fetchFromGitHub {
    owner = "mrlhansen";
    repo = "idrac_exporter";
    rev = "3b311e0e6d602fb0938267287f425f341fbf11da";
    sha256 = "sha256-N8wSjQE25TCXg/+JTsvQk3fjTBgfXTiSGHwZWFDmFKc=";
  };

  vendorHash = "sha256-iNV4VrdQONq7LXwAc6AaUROHy8TmmloUAL8EmuPtF/o=";

  patches = [ ./idrac-exporter/config-from-environment.patch ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) idrac;
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Simple iDRAC exporter for Prometheus";
    mainProgram = "idrac_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ codec ];
  };
}
