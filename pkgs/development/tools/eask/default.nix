{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-MuNQyd4vpJ8Eu57TGPpXiHjwJfdo3FhMjPZYc0MmHRg=";
  };

  npmDepsHash = "sha256-t/DgLItOeD/tUofRlf9mpZg79pC/ml2ReIyp62izn6Y=";

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
