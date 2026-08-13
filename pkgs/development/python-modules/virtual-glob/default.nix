{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pytest,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "virtual-glob";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = "virtual-glob";
    tag = "v${version}";
    hash = "sha256-ocCa8m7mPPvzOZHPrraSEdSJZwRJoYO/Q7nyDbhIFu8=";
  };

  build-system = [
    flit-core
  ];

  optional-dependencies = {
    testing = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "virtual_glob"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    "test_baseline_pathlib"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Globbing of virtual file systems";
    homepage = "https://pypi.org/project/virtual_glob/";
    maintainers = with lib.maintainers; [ PopeRigby ];
    license = lib.licenses.mit;
  };
}
