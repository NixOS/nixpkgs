{ buildGoModule
, fetchFromGitHub
, stdenv
, lib
}:

buildGoModule rec {
  pname = "opentelemetry-collector";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector-contrib";
    rev = "v${version}";
    sha256 = "03713b4bkhcz61maz0r5mkd36kv3rq8rji3qcpi9zf5bkkjs1yzb";
  };

  vendorSha256 = "sha256-sNI2OoDsSNtcQP8rNO4OCboFqSC7v6g4xEPNRKjv3sQ=";
  proxyVendor = true;

  subPackages = [ "cmd/otelcontribcol" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-collector";
    description = "OpenTelemetry Collector";
    license = licenses.asl20;
    maintainers = [ maintainers.uri-canva ];
  };
}
