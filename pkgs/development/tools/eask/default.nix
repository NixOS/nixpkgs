{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-NoYWRIkJEOUsHsjBYTtCNrCmAGG0pqaAHDOc9VcaRwk=";
  };

  npmDepsHash = "sha256-ctIVBrx9fagSX3f2/wn5wWkReOYK0nldFoxTJWVsx0g=";

  dontBuild = true;

  meta = {
    changelog = "https://github.com/emacs-eask/cli/blob/${src.rev}/CHANGELOG.md";
    description = "CLI for building, runing, testing, and managing your Emacs Lisp dependencies";
    homepage = "https://emacs-eask.github.io/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "eask";
    maintainers = with lib.maintainers; [ jcs090218 ];
  };
}
