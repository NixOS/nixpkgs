{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, home-assistant
, python
}:

buildPythonPackage rec {
  pname = "homeassistant-stubs";
<<<<<<< HEAD
  version = "2023.9.2";
=======
  version = "2023.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = python.version != home-assistant.python.version;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "homeassistant-stubs";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-cKBf7S6ZvLlRp0L23mDu1CvG7d1d34LaIev60JPD0TE=";
=======
    hash = "sha256-JWPVubhKLXwY877fbRej04g27vaJTM8qgScLq9IjdiE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
    home-assistant
  ];

  postPatch = ''
    # Relax constraint to year and month
    substituteInPlace pyproject.toml --replace \
      'homeassistant = "${version}"' \
      'homeassistant = "~${lib.versions.majorMinor home-assistant.version}"'
<<<<<<< HEAD
=======
    cat pyproject.toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  pythonImportsCheck = [
    "homeassistant-stubs"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for Home Assistant Core";
    homepage = "https://github.com/KapJI/homeassistant-stubs";
    changelog = "https://github.com/KapJI/homeassistant-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
