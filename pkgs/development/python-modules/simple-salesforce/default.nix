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
  version = "1.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simple-salesforce";
    repo = "simple-salesforce";
    tag = "v${version}";
    hash = "sha256-nrfIyXftS2X2HuuLFRZpWLz/IbRasqUzv+r/HvhxfAw=";
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
    changelog = "https://github.com/simple-salesforce/simple-salesforce/blob/v${version}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
