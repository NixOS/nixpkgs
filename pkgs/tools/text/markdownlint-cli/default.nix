{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-PkvgZn7cQafKO7p5i1fYYZrWjNcFuX700r223qUMN5I=";
  };

  npmDepsHash = "sha256-hh8T2MRjUJQVibd+cY7vkJvBgNDueWuluGE3HxWOCU8=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
