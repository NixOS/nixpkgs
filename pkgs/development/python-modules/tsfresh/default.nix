{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pytestcov
, pytest_xdist
, requests
, numpy
, pandas
, scipy
, statsmodels
, patsy
, scikitlearn
, tqdm
, dask
, distributed
}:

buildPythonPackage rec {
  pname = "tsfresh";
  version = "0.17.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3db06063116c3cca6ef1ad30dcd50a0cc4a4d0688cc34cc8843d9bd400da969";
  };

  checkInputs = [
    pytestCheckHook
    pytestcov
    pytest_xdist
  ];

  # Tries to access the network
  pytestFlagsArray = [
    "tests/"
    "--ignore=tests/integrations"
  ] ++  lib.optionals stdenv.isDarwin [
      "--ignore=tests/units/utilities/test_distribution.py"
  ];

  propagatedBuildInputs = [
    requests
    numpy
    pandas
    scipy
    statsmodels
    patsy
    scikitlearn
    tqdm
    dask
    distributed
  ];

  meta = with lib; {
    description = "Time Series Feature extraction based on scalable hypothesis tests";
    homepage = "https://github.com/blue-yonder/tsfresh";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
