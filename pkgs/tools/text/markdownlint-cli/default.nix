{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-kNnTSSu55zqOwKCPxXhCmGOseDzAWaB6oToyWDSe0Cc=";
  };

  npmDepsHash = "sha256-mpqLI9wYxp9g6uO/Peau51KS4KdNmVulb6sVO1uDC6c=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
