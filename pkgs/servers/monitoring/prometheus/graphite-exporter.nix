{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "graphite-exporter";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "graphite_exporter";
    rev = "v${version}";
    hash = "sha256-UaflfU27GR8VK6AduPDBcQyO3u1uX6YlGP9O4LFwn9A=";
  };

  vendorHash = "sha256-cIl35wbdPCQJLudXphMbjO2Ztd/H1clI43xaMU6T0D4=";

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
