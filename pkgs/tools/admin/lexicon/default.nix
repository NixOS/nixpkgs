{ lib
, fetchFromGitHub
, poetry2nix
, python3
, pyproject ? ./pyproject.toml
, poetrylock ? ./poetry.lock
}:

poetry2nix.mkPoetryApplication {

  inherit pyproject poetrylock;

  python = python3;

  projectDir = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "lexicon";
    rev = "v3.11.2";
    hash = "sha256-z0GaA1O0ctP280QvhdzW7Cxonidz9dOnP6N4RJ+tqfw=";
  };

  meta = with lib; {
    description = "Manipulate DNS records of various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
