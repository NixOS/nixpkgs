{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  python-dateutil,
  langcodes,
  pgpy-dtc,
  validators,
  requests-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sectxt";
  version = "0.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DigitalTrustCenter";
    repo = "sectxt";
    tag = version;
    hash = "sha256-x8HcERUZpOijTEXbbtnG0Co5PiQlO4v5bxKM4CAExnI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
    langcodes
    pgpy-dtc
    validators
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "sectxt" ];

  meta = {
    homepage = "https://github.com/DigitalTrustCenter/sectxt";
    changelog = "https://github.com/DigitalTrustCenter/sectxt/releases/tag/${src.tag}";
    description = "Security.txt parser and validator";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ networkexception ];
  };
}
