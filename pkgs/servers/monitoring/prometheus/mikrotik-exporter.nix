{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "mikrotik-exporter-unstable";
  version = "2021-08-10";

  src = fetchFromGitHub {
    owner = "nshttpd";
    repo = "mikrotik-exporter";
    rev = "4bfa7adfef500ff621a677adfab1f7010af920d1";
    hash = "sha256-xmQTFx2BFBiKxRgfgGSG8h8nb18uviCAORS8VIILFu8=";
  };

  vendorHash = "sha256-rRIQo+367nHdtgfisBka0Yn6f4P75Mm3Ead4CscnRCw=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) mikrotik; };

  meta = {
    inherit (src.meta) homepage;
    description = "Prometheus MikroTik device(s) exporter";
    mainProgram = "mikrotik-exporter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmilata ];
  };
}
