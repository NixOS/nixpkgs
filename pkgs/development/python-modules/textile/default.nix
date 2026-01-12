{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nh3,
  pillow,
  pytest-cov-stub,
  pytestCheckHook,
  regex,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "textile";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textile";
    repo = "python-textile";
    tag = version;
    hash = "sha256-KVDppsvX48loV9OJ70yqmQ5ZSypzcxrjH1j31DcyfM8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    nh3
    regex
  ];

  optional-dependencies = {
    imagesize = [ pillow ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textile" ];

  meta = {
    description = "MOdule for generating web text";
    homepage = "https://github.com/textile/python-textile";
    changelog = "https://github.com/textile/python-textile/blob/${version}/CHANGELOG.textile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pytextile";
  };
}
