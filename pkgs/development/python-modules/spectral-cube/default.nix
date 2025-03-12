{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # build-system
  setuptools-scm,

  # dependencies
  astropy,
  casa-formats-io,
  dask,
  joblib,
  numpy,
  packaging,
  radio-beam,
  tqdm,

  # checks
  aplpy,
  pytest-astropy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.6";
  pyproject = true;

  src = fetchPypi {
    pname = "spectral_cube";
    inherit version;
    hash = "sha256-bjBghr5WrfC4NH5cyiy9RUiCmJSUHBtyD61bd1i/4kM=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    astropy
    casa-formats-io
    dask
    joblib
    numpy
    packaging
    radio-beam
    tqdm
  ] ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    aplpy
    pytest-astropy
    pytestCheckHook
  ];

  # Tests must be run in the build directory.
  preCheck = ''
    cd build/lib
  '';

  # On x86_darwin, this test fails with "Fatal Python error: Aborted"
  # when sandbox = true.
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "spectral_cube/tests/test_visualization.py"
  ];

  pythonImportsCheck = [ "spectral_cube" ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
