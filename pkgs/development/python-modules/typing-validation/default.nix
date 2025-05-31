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
  version = "1.2.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hashberg-io";
    repo = "typing-validation";
    tag = "v${version}";
    hash = "sha256-N0VAxlxB96NA01c/y4xtoLKoiqAxfhJJV0y/3w6H9ek=";
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
    description = "Simple library for runtime type-checking";
    homepage = "https://github.com/hashberg-io/typing-validation";
    changelog = "https://github.com/hashberg-io/typing-validation/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
