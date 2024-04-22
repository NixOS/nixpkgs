{ lib
, buildPythonPackage
, cython
, fetchPypi
, numpy
, oldest-supported-numpy
, packaging
, pandas
, patsy
, pythonAtLeast
, pythonOlder
, scipy
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ImDv3B74nznGcKC9gVGx0IQ1Z3gbyv7GzaBTTrR6lPY=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    scipy
    setuptools
    setuptools-scm
  ] ++ lib.optionals (pythonAtLeast "3.12") [
    numpy
  ];

  dependencies = [
    numpy
    packaging
    pandas
    patsy
    scipy
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
