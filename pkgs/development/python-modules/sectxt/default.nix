{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "0.9.8";
  pyproject = true;

=======
  version = "0.9.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "DigitalTrustCenter";
    repo = "sectxt";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-x8HcERUZpOijTEXbbtnG0Co5PiQlO4v5bxKM4CAExnI=";
=======
    hash = "sha256-CDVfT3ANb4ugLEvrSRTbkZMvZA6rcEwBu2c3pnjsza8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
