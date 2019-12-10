{ lib
, self
, buildPythonPackage
, fetchPypi
, nose
, numpy
, scipy
, pandas
, patsy
, cython
, matplotlib
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cd2194c6642a8754e85f9a6e6912cdf996bebf6ff715d3cc67f65dadfd37cc9";
  };

  checkInputs = with self; [ nose ];
  propagatedBuildInputs = with self; [numpy scipy pandas patsy cython matplotlib];

  # Huge test suites with several test failures
  doCheck = false;

  meta = {
    description = "Statistical computations and models for use with SciPy";
    homepage = https://www.github.com/statsmodels/statsmodels;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
