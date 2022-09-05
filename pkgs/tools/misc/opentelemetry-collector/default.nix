{ buildGoModule
, fetchFromGitHub
, lib
, writeScript
}:

let
  otelcontribcol = writeScript "otelcontribcol" ''
    echo 'ERROR: otelcontribcol is now in `pkgs.opentelemetry-collector-contrib`, call the collector with `otelcorecol` or move to `pkgs.opentelemetry-collector-contrib`' >&2
    exit 1
  '';
in
buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector";
    rev = "v${version}";
    sha256 = "sha256-eNndY3BPdeFO9cihfkPWlDVwWfNZWnjL5gJCxlgJn9c=";
  };
  # there is a nested go.mod
  sourceRoot = "source/cmd/otelcorecol";
  vendorSha256 = "sha256-+i8uKR5EZXTmOnuwoeM6Vpt934v0egSjC951ryXaZS0=";

  preBuild = ''
    # set the build version, can't be done via ldflags
    sed -i -E 's/Version:(\s*)".*"/Version:\1"${version}"/' main.go
  '';

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    cp ${otelcontribcol} $out/bin/otelcontribcol
  '';

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector/blob/v${version}/CHANGELOG.md";
    description = "OpenTelemetry Collector offers a vendor-agnostic implementation on how to receive, process and export telemetry data";
    longDescription = ''
      The OpenTelemetry Collector offers a vendor-agnostic implementation on how
      to receive, process and export telemetry data. In addition, it removes the
      need to run, operate and maintain multiple agents/collectors in order to
      support open-source telemetry data formats (e.g. Jaeger, Prometheus, etc.)
      sending to multiple open-source or commercial back-ends.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ uri-canva jk ];
  };
}
