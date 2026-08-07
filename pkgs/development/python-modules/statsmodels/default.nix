{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  scipy,
  setuptools,
  setuptools-scm,

  # dependencies
  packaging,
  pandas,
  patsy,
}:

buildPythonPackage (finalAttrs: {
  pname = "statsmodels";
  version = "0.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "statsmodels";
    repo = "statsmodels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rr+7vQ+nx8XihoQQECqHlDKvk7xRTdCpQTzs5pBbqmk=";
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
    changelog = "https://github.com/statsmodels/statsmodels/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
  };
})
