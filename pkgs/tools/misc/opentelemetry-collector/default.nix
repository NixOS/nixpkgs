{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "1sgzz7p19vy7grvq1qrfgf5rw3yjnidcsdsky2l2g98i54md25ml";
  };

  vendorSha256 = "1p9i01lwz7yidlmcri3pndmg8brgdrd0ai8sag9xn021hw2sn6qq";
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
