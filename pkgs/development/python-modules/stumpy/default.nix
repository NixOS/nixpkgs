{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  scipy,
  numba,
  pandas,
  dask,
  distributed,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "stumpy";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-S+Rb6pHphXfbqz4VMnN1p7ZrlWB/g7XCdy/T5/Q8VD8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    scipy
    numba
  ];

  nativeCheckInputs = [
    pandas
    dask
    distributed
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stumpy" ];

  pytestFlagsArray = [
    # whole testsuite is very CPU intensive, only run core tests
    # TODO: move entire test suite to passthru.tests
    "tests/test_core.py"
  ];

  meta = {
    description = "Library that can be used for a variety of time series data mining tasks";
    changelog = "https://github.com/TDAmeritrade/stumpy/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
