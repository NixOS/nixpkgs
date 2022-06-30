{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mustache-go";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-3mGxbgxZFL05ZKn6T85tYYjaEkEJbIUkCwlNJTwoIfc=";
  };

  vendorSha256 = "sha256-FYdsLcW6FYxSgixZ5US9cBPABOAVwidC3ejUNbs1lbA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cbroglie/mustache";
    description = "The mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ Zimmi48 ];
    mainProgram = "mustache";
  };
}
