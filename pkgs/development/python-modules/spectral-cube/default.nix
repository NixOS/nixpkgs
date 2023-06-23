{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, aplpy
, joblib
, astropy
, casa-formats-io
, radio_beam
, six
, dask
, pytestCheckHook
, pytest-astropy
, astropy-helpers
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0Fr9PvUShi04z8SUsZE7zHuXZWg4rxt6gwSBb6lr2Pc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [ astropy casa-formats-io radio_beam joblib six dask ];
  nativeCheckInputs = [ pytestCheckHook aplpy pytest-astropy ];

  # On x86_darwin, this test fails with "Fatal Python error: Aborted"
  # when sandbox = true.
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "spectral_cube/tests/test_visualization.py"
  ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
    broken = true;
  };
}
