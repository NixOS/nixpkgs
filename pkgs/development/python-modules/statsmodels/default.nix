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
  version = "0.12.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ad7a7ae7cdd929095684118e3b05836c0ccb08b6a01fe984159475d174a1b10";
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
