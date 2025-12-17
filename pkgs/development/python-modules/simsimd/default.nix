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
  version = "6.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "SimSIMD";
    tag = "v${version}";
    hash = "sha256-r7PEg/A7UXjr7xq2mAk3i1MqdsWITpoV8ZbefoC1+kw=";
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
    changelog = "https://github.com/ashvardanian/SimSIMD/releases/tag/${src.tag}";
    description = "Portable mixed-precision BLAS-like vector math library for x86 and ARM";
    homepage = "https://github.com/ashvardanian/SimSIMD";
    license = with lib.licenses; [
      asl20
      # or
      bsd3
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
