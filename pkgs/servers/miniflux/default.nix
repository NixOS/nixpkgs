{ lib, buildGoModule, fetchFromGitHub, fetchpatch2, installShellFiles, nixosTests }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-JE0sHxmvLGvbgOqH5f7OONAvP93dJLWLAbgTnlNHGHE=";
  };

  vendorHash = "sha256-Y5FcKmvYMN9Q9/VpP8IWclFXt7gl61UiyPJ+Rdmlito=";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestClient" ]; # skip client tests as they require network access

  ldflags = [
    "-s" "-w" "-X miniflux.app/v2/internal/version.Version=${version}"
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
    maintainers = with maintainers; [ rvolosatovs benpye emilylange ];
    mainProgram = "miniflux";
  };
}
