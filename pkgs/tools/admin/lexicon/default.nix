{ lib
, fetchFromGitHub
, poetry2nix
, python3
, pyproject ? ./pyproject.toml
, poetrylock ? ./poetry.lock
}:

let
  pyprojectToml = lib.importTOML pyproject;
  pyprojectVersion = pyprojectToml.tool.poetry.version;
in poetry2nix.mkPoetryApplication {

  inherit pyproject poetrylock;

  python = python3;

  projectDir = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "lexicon";
    rev = "v${pyprojectVersion}";
    hash = "sha256-z0GaA1O0ctP280QvhdzW7Cxonidz9dOnP6N4RJ+tqfw=";
  };

  meta = with lib; {
    description = "Manipulate DNS records of various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
