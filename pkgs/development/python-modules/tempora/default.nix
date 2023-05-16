{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, freezegun
, jaraco-functools
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, pytz
, setuptools-scm
=======
, pythonOlder

# build time
, setuptools-scm

# runtime
, pytz
, jaraco_functools

# tests
, freezegun
, pytest-freezegun
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "tempora";
<<<<<<< HEAD
  version = "5.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E+T8yZfQUJwzBtaEHwPpOBt+Xkayvr+ukVGvkAhfDCY=";
=======
  version = "5.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-txdkhsWUinUgHo0LIe8sI8qAhHQGDfRyGMkilb3OUnY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    jaraco-functools
=======
    jaraco_functools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytz
  ];

  nativeCheckInputs = [
    freezegun
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tempora"
    "tempora.schedule"
    "tempora.timing"
    "tempora.utc"
  ];

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = "https://github.com/jaraco/tempora";
<<<<<<< HEAD
    changelog = "https://github.com/jaraco/tempora/blob/v${version}/NEWS.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
