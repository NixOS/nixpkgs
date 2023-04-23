{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cached-property
, packaging
, pdm-pep517
, requests
, flask
, pytest-httpserver
, pytestCheckHook
, requests-wsgi-adapter
, trustme
}:

buildPythonPackage rec {
  pname = "unearth";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TOdHdw9sVxaYx2VCdt3QIEyBx9mkcPAKjEAdh7umdSQ=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    packaging
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

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
