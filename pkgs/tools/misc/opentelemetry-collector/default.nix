{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "sha256-iJL3EFoBtp4UOLm4/b4JBwzK6iZSTE0cb6EzmlziOLk=";
  };

  vendorSha256 = "sha256-LNlglYys4F7+W7PUmBT9cBnYs7y6AlB9wdaDibaxqC0=";
  proxyVendor = true;

  subPackages = [ "cmd/otelcontribcol" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    description = "OpenTelemetry Collector";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
  };
}
