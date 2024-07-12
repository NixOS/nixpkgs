{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.6.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-wt9EVE3AAnOVJsDHG+qIXSqZ1I2MSITHjGpEGLPWOBY=";
  };

  npmDepsHash = "sha256-+74oklREFCDEa8E0QDBlIzfW943AStJxfXkQDqRGFyo=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
