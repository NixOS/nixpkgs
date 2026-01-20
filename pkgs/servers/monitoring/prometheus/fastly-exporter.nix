{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-MlEscksRj3FR6tDzCZDaQ5iOhLubqvxYdXNH7HCcpfM=";
  };

  vendorHash = "sha256-83qUoQNiQ3D2Bm6D4DoVZDEO8EtUmxBXlpV6F+N1eSA=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = lib.licenses.asl20;
    mainProgram = "fastly-exporter";
  };
}
