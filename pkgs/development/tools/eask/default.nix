{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "eask";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "emacs-eask";
    repo = "cli";
    rev = version;
    hash = "sha256-olVR+TTDfSnQ+eJEb5qbNq96KnRr1WYx74/nC275+gI=";
  };

  npmDepsHash = "sha256-LqJ6cJxrQ3uHuQqXHQ7pfhTlndqFuqoMee9CNSteCP4=";

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
