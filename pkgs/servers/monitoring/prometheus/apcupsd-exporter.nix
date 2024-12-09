{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "apcupsd-exporter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "apcupsd_exporter";
    rev = "v${version}";
    sha256 = "sha256-c0LsUqpJbmWQmbmSGdEy7Bbk20my6iWNLeqtU5BjYlw=";
  };

  vendorHash = "sha256-bvLwHLviIAGmxYY1O0wFDWAMginEUklicrbjIbbPuUw=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) apcupsd; };

  meta = with lib; {
    description = "Provides a Prometheus exporter for the apcupsd Network Information Server (NIS)";
    mainProgram = "apcupsd_exporter";
    homepage = "https://github.com/mdlayher/apcupsd_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ _1000101 mdlayher ];
  };
}
