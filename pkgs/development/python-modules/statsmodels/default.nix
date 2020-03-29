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
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bde3fa0a35a91b45dba7cbc28270b5b649ff1d721c89290883f6e831672d5f0";
  };

  checkInputs = with self; [ nose ];
  propagatedBuildInputs = with self; [numpy scipy pandas patsy cython matplotlib];

  # Huge test suites with several test failures
  doCheck = false;

  meta = {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
