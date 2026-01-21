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
  version = "0.14.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TReHPT5gfTmLhRJs1O16rYnk6difx0TNqxrzGJqZbCo=";
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

  meta = {
    description = "Statistical computations and models for use with SciPy";
    homepage = "https://www.github.com/statsmodels/statsmodels";
    changelog = "https://github.com/statsmodels/statsmodels/releases/tag/v${version}";
    license = lib.licenses.bsd3;
  };
}
