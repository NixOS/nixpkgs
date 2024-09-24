{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-tMbB0u0BxoWGLPOsebwxd0QQcAlpSuhfCRdBEGpLpRU=";
  };

  vendorHash = "sha256-gLhVbd0rca+khY8i776EN/PoySNq/oYYNFbioMjgxPc=";

  ldflags = [
    "-s"
    "-w"
    "-X" "main.BuildVersion=${version}"
    "-X" "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}
