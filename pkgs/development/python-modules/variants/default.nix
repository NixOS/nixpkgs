<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
, six
=======
{ buildPythonPackage
, isPy27
, fetchPypi
, pytest-runner
, setuptools-scm
, pytestCheckHook
, six
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "variants";
  version = "0.2.0";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UR91tM90g8J+TYbZrM8rUxcmeQDBZtF2Nr7u0RiSm5A=";
=======

  src = fetchPypi {
    inherit pname version ;
    sha256 = "511f75b4cf7483c27e4d86d9accf2b5317267900c166d17636beeed118929b90";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "variants"
  ];

  meta = with lib; {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
    changelog = "https://github.com/python-variants/variants/releases/tag/${version}";
=======
  meta = with lib; {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
