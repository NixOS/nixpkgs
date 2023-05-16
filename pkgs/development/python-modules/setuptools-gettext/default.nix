{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "setuptools-gettext";
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-16kzKB0xq3ApQlGQYp12oB7K99QCQMUwqpP54QiI3gg=";
=======
    hash = "sha256-pTjYdezNBFeLCh6cbC+YtHxQB4zrZAFTCjjNQffbHhc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "setuptools_gettext"
  ];

  meta = with lib; {
    changelog = "https://github.com/breezy-team/setuptools-gettext/releases/tag/v${version}";
    description = "setuptools plugin for building mo files";
    homepage = "https://github.com/breezy-team/setuptools-gettext";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
