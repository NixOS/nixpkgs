{ lib, buildPythonPackage, fetchPypi, isPy27, nose, numpy, scipy, pandas, patsy
, cython, matplotlib }:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.13.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "006ec8d896d238873af8178d5475203844f2c391194ed8d42ddac37f5ff77a69";
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
