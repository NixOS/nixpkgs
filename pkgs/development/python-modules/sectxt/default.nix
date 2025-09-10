{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
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
  version = "0.9.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DigitalTrustCenter";
    repo = "sectxt";
    tag = version;
    hash = "sha256-CDVfT3ANb4ugLEvrSRTbkZMvZA6rcEwBu2c3pnjsza8=";
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
