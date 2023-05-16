{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "socid-extractor";
<<<<<<< HEAD
  version = "0.0.25";
=======
  version = "0.0.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "soxoj";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-3aqtuaecqtUcKLp+LRUct5aZb9mP0cE9xH91xWqtb1Q=";
=======
    rev = "v${version}";
    hash = "sha256-tDKwYgW1vEyPzuouPGK9tdTf3vNr+UaosHtQe23srG0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    beautifulsoup4
    python-dateutil
    requests
  ];

  postPatch = ''
<<<<<<< HEAD
    # https://github.com/soxoj/socid-extractor/pull/150
    substituteInPlace requirements.txt \
      --replace "beautifulsoup4~=4.11.1" "beautifulsoup4>=4.10.0"
=======
    # https://github.com/soxoj/socid-extractor/pull/125
    substituteInPlace requirements.txt \
      --replace "beautifulsoup4~=4.10.0" "beautifulsoup4>=4.10.0"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Test require network access
  doCheck = false;

  pythonImportsCheck = [
    "socid_extractor"
  ];

  meta = with lib; {
    description = "Python module to extract details from personal pages";
    homepage = "https://github.com/soxoj/socid-extractor";
<<<<<<< HEAD
    changelog = "https://github.com/soxoj/socid-extractor/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
