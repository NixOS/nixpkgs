{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.2.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-ncJ5oCXe23+an2nFOafMEypFUkwRVW3hZf5pWCKkBNE=";
  };

  npmDepsHash = "sha256-0+jrfXoM6yqkd43lot3JPB+HBTz3XXzqAulGketRsxU=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
