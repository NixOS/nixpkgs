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
  version = "0.13.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2efc02011b7240a9e851acd76ab81150a07d35c97021cb0517887539a328f8a";
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
