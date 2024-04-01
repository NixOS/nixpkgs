{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-ArGoSb4gL0Mpul9wQJWW0aaCpSgtBxqnEiv5wS1eIFY=";
  };

  vendorHash = "sha256-FcUKlvIdXJ3fSvf02zZu4lYa6943s3l2LwFBQ/EqtyY=";

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
