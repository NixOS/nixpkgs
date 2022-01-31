{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector-contrib";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-ktzP+ugG2sa0v8B1Zp47o8Bmpxv98zQyFyWf9QfQRoQ=";
  };
  # proxy vendor to avoid hash missmatches between linux and macOS
  proxyVendor = true;
  vendorSha256 = "sha256-0E52YSWlq1ebHA3kR9Qo/6ufug9R+z1cSD9AfbN/Mi0=";

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
