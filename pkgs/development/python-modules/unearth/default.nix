{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cached-property
, packaging
, pdm-backend
, requests
, flask
, pytest-httpserver
, pytestCheckHook
, requests-wsgi-adapter
, trustme
}:

buildPythonPackage rec {
  pname = "unearth";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1bFSpasqo+UUmhHPezulxdSTF23KOPZsqJadrdWo9kU=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    packaging
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
  ];

  __darwinAllowLocalNetworking = true;

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
