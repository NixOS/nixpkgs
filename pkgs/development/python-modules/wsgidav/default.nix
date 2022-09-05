{ lib
, buildPythonPackage
, cheroot
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, defusedxml
, jinja2
, json5
, python-pam
, pyyaml
, requests
, webtest
}:

buildPythonPackage rec {
  pname = "wsgidav";
  version = "4.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mar10";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LQdS9d2DB4PXqRSzmtZCSyCQI47ncLCG+RSB+goZYoA=";
  };

  propagatedBuildInputs = [
    defusedxml
    jinja2
    json5
    python-pam
    pyyaml
  ];

  checkInputs = [
    cheroot
    pytestCheckHook
    requests
    webtest
  ];

  pythonImportsCheck = [
    "wsgidav"
  ];

  meta = with lib; {
    description = "Generic and extendable WebDAV server based on WSGI";
    homepage = "https://wsgidav.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
