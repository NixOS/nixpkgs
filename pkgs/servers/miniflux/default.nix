{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.39";

in buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    sha256 = "sha256-vvGQc+Ot7w9gZuXV8yCGvMcRIRJJez59bMudX6D34es=";
  };

  vendorSha256 = "sha256-IbOfEdCAuK70+3Z4rWkxVZKPw1rD1hHkohQoWAK1Z3w=";

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
