{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-LUN2gnvdToVi6NOF5gKXVPG0Al1Y/gI66o8dI8bTIgM=";
  };

  npmDepsHash = "sha256-YNgLEe7voCFspOBefXYJ7NtAtbTc0mRmFUN0856j6KM=";

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
