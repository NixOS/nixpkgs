{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
, systemdMinimal
, withSystemd ? false
}:

buildGoModule rec {
  pname = "opentelemetry-collector-contrib";
  version = "0.87.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-b1TCj3aKupqUMQ74O58O5WJfQM9tj1G0ny5YeeilFAM=";
  };

  # proxy vendor to avoid hash missmatches between linux and macOS
  proxyVendor = true;
  vendorHash = "sha256-o/51Z2Zmdza3pNZa0u3j4uG46orE9S7pUsZOXjHKrnI=";

  # there is a nested go.mod
  sourceRoot = "${src.name}/cmd/otelcontribcol";

  # upstream strongly recommends disabling CGO
  # additionally dependencies have had issues when GCO was enabled that weren't caught upstream
  # https://github.com/open-telemetry/opentelemetry-collector/blob/main/CONTRIBUTING.md#using-cgo
  CGO_ENABLED = 0;

  # journalctl is required in-$PATH for the journald receiver tests.
  nativeCheckInputs = lib.optionals stdenv.isLinux [ systemdMinimal ];

  # We don't inject the package into propagatedBuildInputs unless
  # asked to avoid hard-requiring a large package. For the journald
  # receiver to work, journalctl will need to be available in-$PATH,
  # so expose this as an option for those who want more control over
  # it instead of trusting the global $PATH.
  propagatedBuildInputs = lib.optionals withSystemd [ systemdMinimal ];

  preCheck = "export CGO_ENABLED=1";

  # This test fails on darwin for mysterious reasons.
  checkFlags = lib.optionals stdenv.isDarwin
    [ "-skip" "TestDefaultExtensions/memory_ballast" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-telemetry/opentelemetry-collector-contrib/internal/version.Version=v${version}"
  ];

  meta = with lib; {
    description = "OpenTelemetry Collector superset with additional community collectors";
    longDescription = ''
      The OpenTelemetry Collector offers a vendor-agnostic implementation on how
      to receive, process and export telemetry data. In addition, it removes the
      need to run, operate and maintain multiple agents/collectors in order to
      support open-source telemetry data formats (e.g. Jaeger, Prometheus, etc.)
      sending to multiple open-source or commercial back-ends. The Contrib
      edition provides aditional vendor specific receivers/exporters and/or
      components that are only useful to a relatively small number of users and
      is multiple times larger as a result.
    '';
    homepage = "https://github.com/open-telemetry/opentelemetry-collector-contrib";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ uri-canva jk ];
    mainProgram = "otelcontribcol";
  };
}
