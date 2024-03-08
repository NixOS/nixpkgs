{ lib
, buildPythonPackage
, cython
, fetchpatch
, fetchPypi
, matplotlib
, numpy
, oldest-supported-numpy
, pandas
, patsy
, pythonOlder
, scipy
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ImDv3B74nznGcKC9gVGx0IQ1Z3gbyv7GzaBTTrR6lPY=";
  };

  patches = [
    # https://github.com/statsmodels/statsmodels/pull/8969
    (fetchpatch {
      name = "unpin-setuptools-scm.patch";
      url = "https://github.com/statsmodels/statsmodels/commit/cfad8d81166e9b1392ba99763b95983afdb6d61b.patch";
      hash = "sha256-l7cQHodkPm399a+3qIVmXPk/Ca+CqJDyWXWgjb062nM=";
    })
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools-scm
    wheel
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
