{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,

  # Test dependencies
  redisTestHook,
}:

buildGoModule rec {
  pname = "redis_exporter";
  version = "1.76.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-LT0YnyvXz1zQBP8NICws6vhW7qqVSFRzlxfdpB8wOr8=";
  };

  vendorHash = "sha256-y1j7s8R8pd3sp9yOlG2aopQ+GNO2Z7OCO1a9i9L6KM4=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  nativeCheckInputs = [
    redisTestHook
  ];

  preCheck = ''
    export TEST_REDIS_URI="redis://localhost:6379"
  '';

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      skippedTests = [
        "TestLatencySpike" # timing-sensitive

        # The following tests require ad-hoc generated TLS certificates in the source dir.
        # This is not possible in the read-only Nix store.
        "TestCreateClientTLSConfig"
        "TestValkeyTLSScheme"
        "TestCreateServerTLSConfig"
        "TestGetServerCertificateFunc"
        "TestGetConfigForClientFunc"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) redis; };

  meta = with lib; {
    description = "Prometheus exporter for Redis metrics";
    mainProgram = "redis_exporter";
    homepage = "https://github.com/oliver006/redis_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [
      eskytthe
      srhb
      ma27
    ];
  };
}
