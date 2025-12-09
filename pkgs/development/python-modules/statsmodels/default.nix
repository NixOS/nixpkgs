{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  packaging,
  pandas,
  patsy,
  scipy,
  setuptools,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage rec {
  pname = "statsmodels";
  version = "0.14.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3iYOWMzP0s7d+DW1WjVyM9bKhToapPkPdVOlLMccbd8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools_scm[toml]>=8,<9' 'setuptools_scm[toml]'
  '';

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
