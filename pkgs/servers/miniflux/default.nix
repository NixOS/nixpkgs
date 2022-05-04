{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.36";

in buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    sha256 = "sha256-Ly4Ep+ZyjEb1ywXO/W1P1ZDvqSAtJY4wuE8n9jbbeuU=";
  };

  vendorSha256 = "sha256-ZEIQeN7t9Az1W6T2Z+ZKHqs2O8UNNMl0nANM1mVyiTA=";

  nativeBuildInputs = [ installShellFiles ];

  checkPhase = ''
    go test $(go list ./... | grep -v client)
  ''; # skip client tests as they require network access

  ldflags = [
    "-s" "-w" "-X miniflux.app/version.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/miniflux.app $out/bin/miniflux
    installManPage miniflux.1
  '';

  passthru.tests = nixosTests.miniflux;

  meta = with lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = "https://miniflux.app/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs benpye ];
  };
}
