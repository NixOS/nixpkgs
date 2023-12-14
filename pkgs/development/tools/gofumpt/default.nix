{ lib, buildGoModule, fetchFromGitHub }:

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

  checkFlags = [
    # Requires network access (Error: module lookup disabled by GOPROXY=off).
    "-skip=^TestScript/diagnose$"
  ];

  meta = with lib; {
    description = "A stricter gofmt";
    homepage = "https://github.com/mvdan/gofumpt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs ];
    mainProgram = "gofumpt";
  };
}
