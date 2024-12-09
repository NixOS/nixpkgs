{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nh3,
  pillow,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  regex,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "textile";
  version = "4.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "textile";
    repo = "python-textile";
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "MOdule for generating web text";
    homepage = "https://github.com/textile/python-textile";
    changelog = "https://github.com/textile/python-textile/blob/${version}/CHANGELOG.textile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pytextile";
  };
}
