{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tokenize-rt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unasync";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "unasync";
    rev = "v${version}";
    sha256 = "sha256-ZRvmX1fSfSJ1HNEymzhIuUi3tdjFmUoidfr0rN8c7tk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    tokenize-rt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # mess with $PYTHONPATH
    "test_build_py_modules"
    "test_build_py_packages"
    "test_project_structure_after_build_py_packages"
    "test_project_structure_after_customized_build_py_packages"
  ];

  pythonImportsCheck = [ "unasync" ];

  meta = with lib; {
    changelog = "https://github.com/python-trio/unasync/releases/tag/v${version}";
    description = "Project that can transform your asynchronous code into synchronous code";
    homepage = "https://github.com/python-trio/unasync";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
