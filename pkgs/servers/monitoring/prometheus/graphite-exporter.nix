{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-KBqLPKd8XP7PbjHJu1DIQ2ir+Lyk7LEBaNjJCr91LP8=";
  };

  vendorHash = "sha256-he2bmcTNkuKRsNGkn1IkhtOe+Eo/5RLWLYlNFWLo/As=";

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
    description = "An exporter for metrics exported in the Graphite plaintext protocol";
    homepage = "https://github.com/prometheus/graphite_exporter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.misterio77 ];
  };
}
