{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  packaging,
  pandas,
  patsy,
  pythonOlder,
  scipy,
  setuptools,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.14.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7PNQJkP6k6q+XwvfI477WWCVF8TWCoEWMtMfzc6GwtI=";
  };

  build-system = [
    cython
    numpy
    scipy
    setuptools
    setuptools-scm
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=int-conversion"
    ];
  };

  dependencies = [
    numpy
    packaging
    pandas
    patsy
    scipy
  ];

  # Huge test suites with several test failures
  doCheck = false;

  pythonImportsCheck = [ "statsmodels" ];

  meta = with lib; {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    changelog = "https://github.com/statsmodels/statsmodels/releases/tag/v${version}";
    license = licenses.bsd3;
  };
}
