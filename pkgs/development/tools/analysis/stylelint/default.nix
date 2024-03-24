{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.3.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-N3M+PhoUjCB+5ouOPDI9m4vPnEoI6+Gk8DBNOquFCqY=";
  };

  npmDepsHash = "sha256-GRGYDt/qkHZrr7tSM3mPAiBLqUZ0FN1DdDHeBAtNG5w=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
