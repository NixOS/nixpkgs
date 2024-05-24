{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.6.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-yNEXtuemNzpy7gIlVUWM5crP0LpLHmiVYznomC5eGYs=";
  };

  npmDepsHash = "sha256-e9helwaAiW3KtPHOWN7S0VxG87nKj6X4lTHTEdXoRZc=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
