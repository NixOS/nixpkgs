{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-qavqf1qEJD2N33tAuYS9+6dKCqOG5Vxd+eDQurUjef4=";
  };

  vendorSha256 = "sha256-u21rIHh8L32uMiVSrYcz2TcYHgjG4Abo7HukM071wBg=";
  proxyVendor = true;

  subPackages = [ "cmd/otelcontribcol" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    description = "OpenTelemetry Collector";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
  };
}
