{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, numba
, pandas
, dask
, distributed
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stumpy";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-rVl3tIx8iWx2mnaix3V5YnfWWdPBTP8+K2JJKTfctDA=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "stumpy"
  ];

  pytestFlagsArray = [
    # whole testsuite is very CPU intensive, only run core tests
    # TODO: move entire test suite to passthru.tests
    "tests/test_core.py"
  ];

  meta = with lib; {
    description = "Library that can be used for a variety of time series data mining tasks";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
