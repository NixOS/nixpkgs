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
  version = "6.5.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "NumKong";
    tag = "v${version}";
    hash = "sha256-J4lxmsIgzBhG2MSu2LPDY/5IKTNWEG0fDX1EI4NgLB0=";
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

  enabledTestPaths = [
    "scripts/test.py"
  ];

  meta = {
    changelog = "https://github.com/ashvardanian/NumKong/releases/tag/${src.tag}";
    description = "Portable mixed-precision BLAS-like vector math library for x86 and ARM";
    homepage = "https://github.com/ashvardanian/NumKong";
    license =
      with lib.licenses;
      OR [
        asl20
        bsd3
      ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
