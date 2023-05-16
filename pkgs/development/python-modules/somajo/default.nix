{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "somajo";
<<<<<<< HEAD
  version = "2.2.4";
=======
  version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-vO3wEM3WkPQqq+ureJY+cpRHQ4cOLPV6DukA5LOscEM=";
=======
    hash = "sha256-EnYw8TSZLXgB4pZaZBgxaO13PpTDx4lGsdGJ+51A6wE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    regex
  ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "somajo"
  ];

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
