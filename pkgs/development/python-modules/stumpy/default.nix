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
<<<<<<< HEAD
  version = "1.12.0";
=======
  version = "1.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rVl3tIx8iWx2mnaix3V5YnfWWdPBTP8+K2JJKTfctDA=";
=======
    hash = "sha256-ARpXqZpWkbvIEDVkxA1SwlWoxq+3WO6tvv/e7WZ/25c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
