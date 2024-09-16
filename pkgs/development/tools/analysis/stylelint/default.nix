{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.9.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-yMj6X3VI/CKw1VdRXV+7FVJQ6rdZ4E4v069wJZq3+dg=";
  };

  npmDepsHash = "sha256-Ylkx4FPsfEZTy1y2Be0RURHooAev0Z8ew3MJ2wOXjO4=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = [ ];
  };
}
