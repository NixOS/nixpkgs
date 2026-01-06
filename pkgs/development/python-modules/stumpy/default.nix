{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numba,
  numpy,
  scipy,

  # tests
  dask,
  distributed,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "stumpy";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    tag = "v${version}";
    hash = "sha256-S+Rb6pHphXfbqz4VMnN1p7ZrlWB/g7XCdy/T5/Q8VD8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numba
    numpy
    scipy
  ];

  nativeCheckInputs = [
    dask
    distributed
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stumpy" ];

  enabledTestPaths = [
    # whole testsuite is very CPU intensive, only run core tests
    # TODO: move entire test suite to passthru.tests
    "tests/test_core.py"
  ];

  meta = {
    description = "Library that can be used for a variety of time series data mining tasks";
    changelog = "https://github.com/TDAmeritrade/stumpy/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    badPlatforms = [
      # Multiple tests fail with:
      # Segmentation fault (core dumped)
      "aarch64-linux"
    ];
  };
}
