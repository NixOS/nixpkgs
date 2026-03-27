{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  more-itertools,
  pendulum,
  pyjwt,
  pytestCheckHook,
  pytz,
  requests,
  responses,
  setuptools,
  typing-extensions,
  zeep,
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "1.12.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simple-salesforce";
    repo = "simple-salesforce";
    tag = "v${version}";
    hash = "sha256-eMO/K6W9ROljYxR3gK9QjCHdlbAuN4DYjOyTO1WcalQ=";
  };

  nativeBuildInputs = [ setuptools ];

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

  pythonImportsCheck = [ "simple_salesforce" ];

  meta = {
    description = "Very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    changelog = "https://github.com/simple-salesforce/simple-salesforce/blob/${src.tag}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
