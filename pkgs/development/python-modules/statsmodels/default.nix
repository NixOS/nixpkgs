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
  version = "0.12.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a271b4ccec190148dccda25f0cbdcbf871f408fc1394a10a7dc1af4a62b91c8e";
  };

  nativeBuildInputs = [ cython ];
  checkInputs = [ nose ];
  requiredPythonModules = [ numpy scipy pandas patsy matplotlib ];

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
