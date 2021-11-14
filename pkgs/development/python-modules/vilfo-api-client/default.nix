{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, getmac
, requests
, pytestCheckHook
, responses
, semver
}:

buildPythonPackage rec {
  pname = "vilfo-api-client";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ManneW";
    repo = "vilfo-api-client-python";
    rev = version;
    sha256 = "0aqzp7qh5xvmcsrpyjdgbwwg4r3w5zw4bz1bjjmjjn91zmp82klg";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    getmac
    requests
    semver
  ];

  checkInputs = [
    pytestCheckHook
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
