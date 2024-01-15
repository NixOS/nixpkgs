{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "markdownlint-cli";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "igorshubovych";
    repo = "markdownlint-cli";
    rev = "v${version}";
    hash = "sha256-3PiienQjyJQ/ElY4j0Ccu+r6KtIu1kuPlobHqXE0GY4=";
  };

  npmDepsHash = "sha256-WoXyWn58E4+Lj3LWqr/8JbvAo5IcjLgnzhIt59bSqV4=";

  dontNpmBuild = true;

  meta = {
    description = "Command line interface for MarkdownLint";
    homepage = "https://github.com/igorshubovych/markdownlint-cli";
    license = lib.licenses.mit;
    mainProgram = "markdownlint";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
