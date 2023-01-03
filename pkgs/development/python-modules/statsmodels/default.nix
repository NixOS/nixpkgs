{ lib
, buildPythonPackage
, cython
, fetchPypi
, matplotlib
, numpy
, pandas
, patsy
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.13.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WTUmrK4cD9oOpsSEOfZ8OUMJTFQv52n4uQ/p5sbMSHE=";
  };

  nativeBuildInputs = [
    cython
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
    patsy
    matplotlib
  ];

  # Huge test suites with several test failures
  doCheck = false;

  pythonImportsCheck = [
    "statsmodels"
  ];

  meta = with lib; {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    changelog = "https://github.com/statsmodels/statsmodels/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
