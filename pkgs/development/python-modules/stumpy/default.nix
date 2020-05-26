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

buildPythonPackage {
  pname = "stumpy";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "115e477c1eec9291ab7c1fd8da30d67a70854f8e"; # no git version tag
    sha256 = "0s2s3y855jjwdb7p55zx8lknplz58ghpw547yzmqisacr968b67w";
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

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A powerful and scalable library that can be used for a variety of time series data mining tasks";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
