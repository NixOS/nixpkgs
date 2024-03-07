{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, gofumpt
}:

buildGoModule rec {
  pname = "gofumpt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3buGLgxAaAIwLXWLpX+K7VRx47DuvUI4W8vw4TuXSts=";
  };

  vendorHash = "sha256-W0WKEQgOIFloWsB4E1RTICVKVlj9ChGSpo92X+bjNEk=";

  CGO_ENABLED = "0";

  ldflags = "-s -w -X main.version=v${version}";

  checkFlags = [
    # Requires network access (Error: module lookup disabled by GOPROXY=off).
    "-skip=^TestScript/diagnose$"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = gofumpt;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    changelog = "https://github.com/mvdan/gofumpt/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs katexochen ];
    mainProgram = "gofumpt";
  };
}
