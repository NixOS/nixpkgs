{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-YFgAS4WReyMnzb6FOeRUXHf1LUgknH5gWObiZNKMbv8=";
  };

  vendorSha256 = "sha256-DTZLYF3BoQGou59KaL56pkxySsoQ0xeJ5aF/SkewziE=";
  proxyVendor = true;

  CGO_ENABLED = 0;

  subPackages = [ "cmd/otelcontribcol" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    description = "OpenTelemetry Collector";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
  };
}
