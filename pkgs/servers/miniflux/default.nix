{ lib, buildGo121Module, fetchFromGitHub, fetchpatch, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.50";

in buildGo121Module {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    sha256 = "sha256-+oNF/Zwc1Z/cu3SQC/ZTekAW5Qef9RKrdszunLomGII=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/miniflux/v2/pull/2193, remove after 2.0.50
      name = "miniflux-user-agent-regression.patch";
      url = "https://github.com/miniflux/v2/commit/7a03291442a4e35572c73a2fcfe809fa8e03063e.patch";
      hash = "sha256-tJ1l5rqD0x0xtQs+tDwpFHOY+7k6X02bkwVJo6RAdb8=";
    })
  ];

  vendorHash = "sha256-jLyjQ+w/QS9uA0pGWF2X6dEfOifcI2gC2sgi1STEzpU=";

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
    maintainers = with maintainers; [ rvolosatovs benpye ];
    mainProgram = "miniflux";
  };
}
