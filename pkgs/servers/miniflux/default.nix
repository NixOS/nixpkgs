{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-vXSOHZt6Ov5g4fQBg0bubCfn76aaVrjw2b+LRebbV6s=";
  };

  vendorHash = "sha256-p31kwJZQMYff5Us6mXpPmxbPrEXyxU6Sipf4LKSG3wU=";

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
