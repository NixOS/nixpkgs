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
, wheel
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aHXH1onpZtlI8V64FqtWFvSShwaxgM9HD9WQerb2R6Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'oldest-supported-numpy' 'numpy' \
      --replace 'setuptools_scm[toml]~=' 'setuptools_scm[toml]>='
  '';

  nativeBuildInputs = [
    cython
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
