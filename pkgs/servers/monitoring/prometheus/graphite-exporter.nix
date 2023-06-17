{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-ZsRN/h96Lt0znXmtMGjR6TXKa1ka0rbk/XXNVolBNk8=";
  };

  vendorHash = "sha256-vW/iODlOWD8JmoDO6Ty+Eajoj0IAHak/abWW2OSp34M=";

  preCheck = let
    skippedTests = [
      "TestBacktracking"
      "TestInconsistentLabelsE2E"
      "TestIssue111"
      "TestIssue61"
      "TestIssue90"
    ];
  in ''
    buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) graphite; };

  meta = {
    description = "An exporter for metrics exported in the Graphite plaintext protocol";
    homepage = "https://github.com/prometheus/graphite_exporter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.misterio77 ];
  };
}
