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
  version = "4.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mar10";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DEUoKoFELIOg5KX6hL1VgR18dtsery4ZzKksrxl0D7Q=";
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

  __darwinAllowLocalNetworking = true;

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
    changelog = "https://github.com/mar10/wsgidav/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
