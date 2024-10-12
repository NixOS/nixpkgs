{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mustache-go";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-A7LIkidhpFmhIjiDu9KdmSIdqFNsV3N8J2QEo7yT+DE=";
  };

  vendorHash = "sha256-FYdsLcW6FYxSgixZ5US9cBPABOAVwidC3ejUNbs1lbA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cbroglie/mustache";
    description = "Mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ Zimmi48 ];
    mainProgram = "mustache";
  };
}
