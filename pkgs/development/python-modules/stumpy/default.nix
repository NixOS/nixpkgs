{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, numba
, pandas
, dask
, distributed
, coverage
, flake8
, black
, pytest
, codecov
}:

buildPythonPackage rec {
  pname = "stumpy";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "v${version}";
    sha256 = "1ydwqdvyq5cfcm8mqky0807f2wklijng5nmqbcj0bb2ibprrzs69";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    numba
  ];

  checkInputs = [
    pandas
    dask
    distributed
    coverage
    flake8
    black
    pytest
    codecov
  ];

  # ignore changed numpy operations
  checkPhase = ''
    pytest -k 'not allc'
  '';

  meta = with lib; {
    description = "A powerful and scalable library that can be used for a variety of time series data mining tasks";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
