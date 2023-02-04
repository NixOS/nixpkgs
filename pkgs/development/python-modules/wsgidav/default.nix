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
, setuptools
, webtest
}:

buildPythonPackage rec {
  pname = "wsgidav";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mar10";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iNyXY0txKX4X1+O27T7my8dfs8wqXoG7Kuo9yN9SRnY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    defusedxml
    jinja2
    json5
    python-pam
    pyyaml
  ];

  nativeCheckInputs = [
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
