{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-2u8grG5n0XkBS6zNxYrPyL+HP5/jEe/bXLt/1l759o4=";
  };

  vendorHash = "sha256-wt2eDCNZAss3zSqvXeKTlsrPfj8pMXKWa3Yb33uuW0M=";

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
