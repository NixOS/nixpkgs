{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typing-extensions";
<<<<<<< HEAD
  version = "4.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "4.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "typing_extensions";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-t13cJk8LpWFdt7ohfa65lwGtKVNTxF+elZYzN87u/7I=";
=======
    hash = "sha256-XLX0p5E51plgez72IqHe2vqE4RWrACTg2cBEqUecp8s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Tests are not part of PyPI releases. GitHub source can't be used
  # as it ends with an infinite recursion
  doCheck = false;

  pythonImportsCheck = [
    "typing_extensions"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Backported and Experimental Type Hints for Python";
    changelog = "https://github.com/python/typing_extensions/blob/${version}/CHANGELOG.md";
=======
    description = "Backported and Experimental Type Hints for Python 3.5+";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/python/typing";
    license = licenses.psfl;
    maintainers = with maintainers; [ pmiddend ];
  };
}
