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
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wcc7xbwlf8r2diw9fnzf4bg9h5cg406w7phd3dz37hx17yfi3ha";
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
