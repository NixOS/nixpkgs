{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
=======
, fetchPypi
, isPy27
, decorator
, six
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "validators";
<<<<<<< HEAD
  version = "0.21.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-validators";
    repo = "validators";
    rev = "refs/tags/${version}";
    hash = "sha256-b5K1WP+cEAjPBXu9sAZQf1J5H7PLnn94400Zd/0Y9ew=";
  };

  nativeBuildInputs = [
    poetry-core
=======
  version = "0.20.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JBSM5OZBAKLV4mcjPiPnr+tVMWtH0w+q5+tucpK8Imo=";
  };

  propagatedBuildInputs = [
    decorator
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "validators"
  ];

  meta = with lib; {
    description = "Python Data Validation for Humans";
    homepage = "https://github.com/python-validators/validators";
    changelog = "https://github.com/python-validators/validators/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "Python Data Validation for Humans™";
    homepage = "https://github.com/kvesteri/validators";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
