{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, pytest-subtests
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "tzdata";
  version = "2022.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/l+Gbt3YuW6fy6l4+OUDyQmxnqfv2hHlLjlJS606e/o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  pythonImportsCheck = [
    "tzdata"
  ];

  meta = with lib; {
    description = "Provider of IANA time zone data";
    homepage = "https://github.com/python/tzdata";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
