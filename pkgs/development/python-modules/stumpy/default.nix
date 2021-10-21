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
}:

buildPythonPackage rec {
  pname = "stumpy";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "TDAmeritrade";
    repo = "stumpy";
    rev = "v${version}";
    sha256 = "0x5kac8fqsi3fkfwjdn0d7anslprxaz6cizky9cyj0rpbp0b0yc3";
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
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A powerful and scalable library that can be used for a variety of time series data mining tasks";
    homepage = "https://github.com/TDAmeritrade/stumpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
