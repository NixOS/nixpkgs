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
  looseversion,
  radio-beam,

  # checks
  aplpy,
  pytest-astropy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gJzrr3+/FsQN/HHDERxf/NECArwOaTqFwmI/Q2Z9HTM=";
  };

  patches = [ ./distutils-looseversion.patch ];

  build-system = [ setuptools-scm ];

  dependencies = [
    astropy
    casa-formats-io
    dask
    joblib
    looseversion
    radio-beam
  ];

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
  disabledTestPaths = lib.optionals stdenv.isDarwin [ "spectral_cube/tests/test_visualization.py" ];

  pythonImportsCheck = [ "spectral_cube" ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
