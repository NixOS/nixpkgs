{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    hash = "sha256-LF8ydXe+wAES0l5Lip6+30PXThGpciQgsclTE0YGxqg=";
  };

  vendorHash = "sha256-SzXouH7xVZ/J8sReT1m9UBAA567crgxoUiYqJIEFBlw=";

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    mainProgram = "github-commenter";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
  };
}
