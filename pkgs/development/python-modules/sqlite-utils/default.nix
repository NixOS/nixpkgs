{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, click
, click-default-group
, python-dateutil
, sqlite-fts4
, tabulate
<<<<<<< HEAD
, pluggy
, pytestCheckHook
, hypothesis
, testers
, sqlite-utils
=======
, pytestCheckHook
, hypothesis
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "sqlite-utils";
<<<<<<< HEAD
  version = "3.35.1";
=======
  version = "3.31";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-4PA+aXawW9t6XFZFSXGg6YD8Ftv9NRK7073KxPDkNw4=";
=======
    hash = "sha256-VJifPQntEh+d+Xgx0EFziuSHcdPKhQCJRvG8GIQQmoo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "click-default-group-wheel" "click-default-group"
  '';

  propagatedBuildInputs = [
    click
    click-default-group
    python-dateutil
    sqlite-fts4
    tabulate
<<<<<<< HEAD
    pluggy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "sqlite_utils"
  ];

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion {
    package = sqlite-utils;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python CLI utility and library for manipulating SQLite databases";
    homepage = "https://github.com/simonw/sqlite-utils";
    changelog = "https://github.com/simonw/sqlite-utils/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar techknowlogick ];
  };
}
