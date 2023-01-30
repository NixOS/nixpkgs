{ lib
, buildPythonPackage
, fetchFromGitHub
, getmac
, pytestCheckHook
, pythonOlder
, requests
, responses
, semver
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "vilfo-api-client";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    rev = "refs/tags/${version}";
    hash = "sha256-j06Bbv0hWSmrlCv8RfgvfGTyOF+vSX+zZnX3AvG5Hys=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    getmac
    requests
    semver
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    responses
  ];

  pythonImportsCheck = [
    "vilfo"
  ];

  meta = with lib; {
    description = "Simple wrapper client for the Vilfo router API";
    homepage = "https://github.com/ManneW/vilfo-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
