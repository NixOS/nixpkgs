{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cached-property
, packaging
<<<<<<< HEAD
, pdm-backend
=======
, pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, requests
, flask
, pytest-httpserver
, pytestCheckHook
, requests-wsgi-adapter
, trustme
}:

buildPythonPackage rec {
  pname = "unearth";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-1bFSpasqo+UUmhHPezulxdSTF23KOPZsqJadrdWo9kU=";
  };

  nativeBuildInputs = [
    pdm-backend
=======
    hash = "sha256-TOdHdw9sVxaYx2VCdt3QIEyBx9mkcPAKjEAdh7umdSQ=";
  };

  nativeBuildInputs = [
    pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    packaging
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    flask
    pytest-httpserver
    pytestCheckHook
    requests-wsgi-adapter
    trustme
  ];

  pythonImportsCheck = [
    "unearth"
  ];

  meta = with lib; {
    description = "A utility to fetch and download Python packages";
    homepage = "https://github.com/frostming/unearth";
    changelog = "https://github.com/frostming/unearth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ betaboon ];
  };
}
