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
  version = "6.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "simsimd";
    tag = "v${version}";
    hash = "sha256-FM1ge3opt0hwVSjNQWOAYeG6tDIwVLSbu9mZOJBxvJY=";
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
    license = with lib.licenses; [
      asl20
      # or
      bsd3
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
