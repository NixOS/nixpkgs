{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "9.4.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-C2lm9E60mjMCkMnUNdm3P+OXx0nUc7JwV1zNYnmlVt0=";
  };

  vendorHash = "sha256-wbkm6b8xTGAQ4bCjIOVvJVA7sckPxtDiwMcjglaL/Pk=";

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) fastly;
  };

  meta = with lib; {
    description = "Prometheus exporter for the Fastly Real-time Analytics API";
    homepage = "https://github.com/fastly/fastly-exporter";
    license = licenses.asl20;
    teams = [ teams.deshaw ];
    mainProgram = "fastly-exporter";
  };
}
