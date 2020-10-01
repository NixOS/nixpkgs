{ lib
, buildPythonPackage
, fetchPypi
, isPy27
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
  version = "0.12.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c7d6707ad3112b67f564abaf1845d3c02ecc7174c2d990d539f45c37e98ad35";
  };

  nativeBuildInputs = [ cython ];
  checkInputs = [ nose ];
  propagatedBuildInputs = [ numpy scipy pandas patsy matplotlib ];

  # Huge test suites with several test failures
  doCheck = false;
  pythonImportsCheck = [ "statsmodels" ];

  meta = {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
