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
  version = "0.7.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z1RBGze3qUHzzf3ymu7ivxgWSor8o1xGe5f+q2JuZx4=";
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

  checkInputs = [
    flask
    pytest-httpserver
    pytestCheckHook
    requests-wsgi-adapter
    trustme
  ];

  meta = with lib; {
    homepage = "https://github.com/frostming/unearth";
    description = "A utility to fetch and download python packages";
    license = licenses.mit;
    maintainers = with maintainers; [ betaboon ];
  };
}
