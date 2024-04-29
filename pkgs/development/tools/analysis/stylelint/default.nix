{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.4.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-N689OjxUo3KPN3mfNQ1cKYoe8DXcVTNkUO4NuZPGuXI=";
  };

  npmDepsHash = "sha256-V+hiUMenskHV+ccYysBDD5WoQH9vem+uEfQ5SWEdVFU=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
