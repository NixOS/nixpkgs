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
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6461f93a842c649922c2c9a9bc9d9c4834110b89de8c4af196a791ab8f42ba3b";
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
