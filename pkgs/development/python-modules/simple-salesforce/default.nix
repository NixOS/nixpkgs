{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, more-itertools
, pendulum
, pyjwt
, pytestCheckHook
, pythonOlder
, pytz
, requests
, responses
, setuptools
, typing-extensions
, zeep
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "1.12.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simple-salesforce";
    repo = "simple-salesforce";
    rev = "refs/tags/v${version}";
    hash = "sha256-nrfIyXftS2X2HuuLFRZpWLz/IbRasqUzv+r/HvhxfAw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    more-itertools
    pendulum
    pyjwt
    requests
    typing-extensions
    zeep
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    responses
  ];

  pythonImportsCheck = [
    "simple_salesforce"
  ];

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    changelog = "https://github.com/simple-salesforce/simple-salesforce/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
