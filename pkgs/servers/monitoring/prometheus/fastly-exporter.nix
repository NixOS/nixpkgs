{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "fastly-exporter";
  version = "9.2.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "fastly-exporter";
    rev = "v${version}";
    hash = "sha256-x3BhFY6F8RMlEOefw5jinbosV3ebAADmnM2Rp7uBcvk=";
  };

  vendorHash = "sha256-sXDOetqTxFEr16tOmM9nomg/v18rdVx3pG67Yiw6g5E=";

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
