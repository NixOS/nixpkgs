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
  version = "6.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashvardanian";
    repo = "simsimd";
    tag = "v${version}";
    hash = "sha256-9+m1NkXwlHtqeXvsyYhhT+7KNZ1aFUxxA/+i3GbQvgs=";
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
    changelog = "https://github.com/ashvardanian/SimSIMD/releases/tag/v${version}";
    description = "Portable mixed-precision BLAS-like vector math library for x86 and ARM";
    homepage = "https://github.com/ashvardanian/simsimd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
