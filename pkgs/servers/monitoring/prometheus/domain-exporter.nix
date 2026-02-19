{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-qk/shaWY7M2JDx6W4e7z8Nv7yWUZKZNGZE/mj4zCZHw=";
  };

  vendorHash = "sha256-1j5alRdCbO/ZJhuvVuiSsNBMRm7RqMOY/ex6US7qaxU=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

  meta = {
    homepage = "https://github.com/caarlos0/domain_exporter";
    description = "Exports the expiration time of your domains as prometheus metrics";
    mainProgram = "domain_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mmilata
      peterhoeg
      caarlos0
    ];
  };
}
