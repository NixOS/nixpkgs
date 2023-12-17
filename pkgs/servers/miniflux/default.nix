{ lib, buildGo121Module, fetchFromGitHub, installShellFiles, nixosTests }:

let
  pname = "miniflux";
  version = "2.0.51";

in buildGo121Module {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = "v2";
    rev = version;
    hash = "sha256-gffiZOsHUYTDEjIdKUPyKbsdRKX890aG6GY72LYESkA=";
  };

  vendorHash = "sha256-yO4sNOkEDnM9eETE68C++dPnAfcoSMXznf5Nq4/iQmA=";

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
