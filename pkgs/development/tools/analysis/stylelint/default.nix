{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.5.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-kbcf0OPAIeEdh5YI2qqaLJww+ZejfXt/llJTK10nE0M=";
  };

  npmDepsHash = "sha256-tENUngFWjrmsJErvbmFflwGL0uxou0vQjC/MwfCpm+Y=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
