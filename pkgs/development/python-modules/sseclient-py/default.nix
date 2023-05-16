<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
{ buildPythonPackage, fetchFromGitHub, lib, python }:

buildPythonPackage rec {
  pname = "sseclient-py";
  version = "1.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mpetazzoni";
    repo = "sseclient";
    rev = "sseclient-py-${version}";
<<<<<<< HEAD
    hash = "sha256-rNiJqR7/e+Rhi6kVBY8gZJZczqSUsyszotXkb4OKfWk=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sseclient"
  ];

  pytestFlagsArray = [
    "tests/unittests.py"
  ];
=======
    sha256 = "096spyv50jir81xiwkg9l88ycp1897d3443r6gi1by8nkp4chvix";
  };

  # based on tox.ini
  checkPhase = ''
    ${python.interpreter} tests/unittests.py
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Pure-Python Server Side Events (SSE) client";
    homepage = "https://github.com/mpetazzoni/sseclient";
<<<<<<< HEAD
    changelog = "https://github.com/mpetazzoni/sseclient/releases/tag/sseclient-py-${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
