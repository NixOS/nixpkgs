{ lib
, stdenv
, aplpy
, astropy
, buildPythonPackage
, casa-formats-io
, dask
, fetchPypi
, joblib
, pytest-astropy
, pytestCheckHook
, pythonOlder
, radio-beam
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7wfvsravSkAGkTtuPE01wPW7wEHKVWT8kYQn93Q2B4M=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    casa-formats-io
    radio-beam
    joblib
    dask
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
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "spectral_cube/tests/test_visualization.py"
  ];

  pythonImportsCheck = [
    "spectral_cube"
  ];

  meta = with lib; {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
