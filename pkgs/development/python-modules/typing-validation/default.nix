{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pytestCheckHook,

  pythonOlder,

  setuptools,
  setuptools-scm,
  wheel,

  numpy,

  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typing-validation";
  version = "1.2.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hashberg-io";
    repo = "typing-validation";
    rev = "refs/tags/v${version}";
    hash = "sha256-0scXoAPkx/VBIbNRMtFoRRbmGpC2RzNRmQG4mRXSxrs=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  pythonImportsCheck = [ "typing_validation" ];

  meta = with lib; {
    description = "A simple library for runtime type-checking";
    homepage = "https://github.com/hashberg-io/typing-validation";
    changelog = "https://github.com/hashberg-io/typing-validation/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
