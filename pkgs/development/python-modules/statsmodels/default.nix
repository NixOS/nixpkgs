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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fhsq3bz5ya54ipa0cb8qgfj7gfgxprv4briig0ly4r11rj23wv5";
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
