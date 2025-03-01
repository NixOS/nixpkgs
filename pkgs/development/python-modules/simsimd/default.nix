{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
  tabulate,
}:

buildPythonPackage rec {
  pname = "simsimd";
  version = "6.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "simsimd";
    tag = "v${version}";
    hash = "sha256-8D3mMhGrHATqxc79OvfcG92UnDGjU6YDfFjReXdR6cs=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "simsimd"
  ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
    tabulate
  ];

  pytestFlagsArray = [
    "scripts/test.py"
  ];

  meta = {
    changelog = "https://github.com/ashvardanian/SimSIMD/releases/tag/${src.tag}";
    description = "Portable mixed-precision BLAS-like vector math library for x86 and ARM";
    homepage = "https://github.com/ashvardanian/simsimd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
