{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "stylelint";
  version = "16.8.1";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    rev = version;
    hash = "sha256-LhLA1JxaTtdoXfylaDLiyW2gi0xy2l5Rm3B67+z1Wdc=";
  };

  npmDepsHash = "sha256-xi6we8XOGaLqwTLrF0Enpx7jQgbHOSItuqzlvvNNBWQ=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = licenses.mit;
    maintainers = [ ];
  };
}
