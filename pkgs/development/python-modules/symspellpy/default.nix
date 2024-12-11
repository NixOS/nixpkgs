{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "6.7.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "symspellpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZnkZE7v4o0o6iPdkjCycDgVdLhsE3Vn1uuGT7o0F86I=";
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
    changelog = "https://github.com/mammothb/symspellpy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
