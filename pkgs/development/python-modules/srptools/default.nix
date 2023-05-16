<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, six
, pytestCheckHook
, pythonOlder
}:
=======
{ lib, buildPythonPackage, fetchPypi, six, pytest, pytest-runner }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "srptools";
  version = "1.0.1";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f6QzclahVC6PW7S+0Z4dmuqY/l/5uvdmkzQqHdasfJY=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "srptools"
  ];

  meta = with lib; {
    description = "Module to implement Secure Remote Password (SRP) authentication";
    homepage = "https://github.com/idlesign/srptools";
    changelog = "https://github.com/idlesign/srptools/blob/v${version}/CHANGELOG";
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fa4337256a1542e8f5bb4bed19e1d9aea98fe5ff9baf76693342a1dd6ac7c96";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest pytest-runner ];

  meta = with lib; {
    description = "Python-Tools to implement Secure Remote Password (SRP) authentication";
    homepage = "https://github.com/idlesign/srptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
