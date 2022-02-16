{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector-contrib";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-JRkS51ybFnvCn3pKhDeXO0R23wzT1uso1PtXZllF1fA=";
  };
  # proxy vendor to avoid hash missmatches between linux and macOS
  proxyVendor = true;
  vendorSha256 = "sha256-4MnUDakBfo3nhSqMjDYiqx6FNZvAB/9DE1yxOvmQAAk=";

  subPackages = [ "cmd/otelcontribcol" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-telemetry/opentelemetry-collector-contrib/internal/version.Version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector-contrib";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/v${version}/CHANGELOG.md";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ uri-canva jk ];
  };
}
