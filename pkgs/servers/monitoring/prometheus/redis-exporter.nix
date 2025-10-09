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
  version = "1.78.0";

  src = fetchFromGitHub {
    owner = "oliver006";
    repo = "redis_exporter";
    rev = "v${version}";
    sha256 = "sha256-Nj2SvnKk04kTVm4O1v809WslW/egKVsZO0b9zTKIoWQ=";
  };

  vendorHash = "sha256-7/7O61tOEUsRVkFVkmOiHqgxmFDmwaw8s97aOQr89Mg=";

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
