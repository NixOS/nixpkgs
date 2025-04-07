{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pythonOlder,

  pytestCheckHook,

  setuptools,

  # for testing
  numpy,
  importlib-resources,

  # requirements
  editdistpy,
}:

buildPythonPackage rec {
  pname = "symspellpy";
  version = "6.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "symspellpy";
    tag = "v${version}";
    hash = "sha256-isxANYSiwN8pQ7/XfMtO7cyoGdTyrXYOZ6C5rDJsJIs=";
  };

  build-system = [ setuptools ];

  dependencies = [ editdistpy ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    importlib-resources
  ];

  pythonImportsCheck = [
    "symspellpy"
    "symspellpy.symspellpy"
  ];

  meta = {
    description = "Python port of SymSpell v6.7.1, which provides much higher speed and lower memory consumption";
    homepage = "https://github.com/mammothb/symspellpy";
    changelog = "https://github.com/mammothb/symspellpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
