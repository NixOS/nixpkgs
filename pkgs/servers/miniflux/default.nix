{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.38";

in buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    sha256 = "sha256-y6g5HGIgEgb+Z26aKgj90oHIrXmrTmrpQyflKPOS0No=";
  };

  vendorSha256 = "sha256-ED4Rq+ks+75PdJvIye17eI7MLEJdP9yXHhbonqw2oMI=";

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
