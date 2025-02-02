{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-BW2Kw5arYJStz468uLokNj7c1nFVdvYMPdVoaU6dRts=";
  };

  npmDepsHash = "sha256-lgkPyu7kM6ZW/MgO2eBsf46Z767wDObrgh8dCLl+dGA=";

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
