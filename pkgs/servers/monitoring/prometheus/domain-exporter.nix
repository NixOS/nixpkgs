{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-5GyDQkd8zXZ9TtauWfW9uW8xkgtEICFm6f4Q/jVqOBc=";
  };

  vendorHash = "sha256-EPpzrig40WXt5mo/vPTFjh+gYdFOlMknjNJHNChlQwk=";

  doCheck = false; # needs internet connection

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) domain;
  };

  meta = with lib; {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    mainProgram = "domain_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [
      mmilata
      prusnak
      peterhoeg
      caarlos0
    ];
  };
}
