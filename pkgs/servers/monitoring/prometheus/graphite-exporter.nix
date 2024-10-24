{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-GiXg4FkEDveKI3JPRJ5bYmdfmcum5abN70ESwH0S7EA=";
  };

  vendorHash = "sha256-SXxjCXWJcVAyTjH77ga1pFdudUjQfDJCD78fiDlw9Y0=";

  checkFlags =
    let
      skippedTests = [
        "TestBacktracking"
        "TestInconsistentLabelsE2E"
        "TestIssue111"
        "TestIssue61"
        "TestIssue90"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) graphite; };

  meta = {
    description = "Exporter for metrics exported in the Graphite plaintext protocol";
    homepage = "https://github.com/prometheus/graphite_exporter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.misterio77 ];
  };
}
