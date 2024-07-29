{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.7.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-teoEVkSLK3pdSY6Z9aq/4/V028mLufDrPt/Ff9iO64w=";
  };

  npmDepsHash = "sha256-daimn//rZhj7O/JCI2rdHn/H9o4yOYQcAL7Iu04RBlk=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = [ ];
  };
}
