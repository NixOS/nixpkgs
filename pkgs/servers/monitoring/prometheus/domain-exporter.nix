{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "domain-exporter";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "domain_exporter";
    rev = "v${version}";
    hash = "sha256-ExMCdrel9uRCn31cKsZkrb3yojvO0UvJYytAn1eptyo=";
  };

  vendorHash = "sha256-NfwxwfUpVNSARcVqOQgM++PkyLmTvXuN9nYBEPX2peY=";

  doCheck = false; # needs internet connection

  passthru.tests = { inherit (nixosTests.prometheus-exporters) domain; };

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
