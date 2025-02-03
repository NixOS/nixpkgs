{ lib, buildGoModule, fetchFromGitHub, fetchpatch2, installShellFiles, nixosTests }:

buildGoModule rec {
  pname = "miniflux";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "v2";
    rev = "refs/tags/${version}";
    hash = "sha256-1EH8KtKdAssxLk0IyhJsbrFU1obDTvmaGtFyLVlnOdQ=";
  };

  patches = [
    (fetchpatch2 {
      # Fix panic during YouTube channel feed discovery
      name = "miniflux-pr2742.patch";
      url = "https://github.com/miniflux/v2/commit/79ea9e28b5a8c09f4d1dcbf31b661fb5f8e85e6a.patch";
      hash = "sha256-BZPv83QsJ6iJs12FLALfTN//VZL/BfGkXs3Pzn9cGeU=";
    })
  ];

  vendorHash = "sha256-kr2qCKuwp6Fpr0zEjggqk4Mff3V9pxGLU71lRhdRrW8=";

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
