{ lib
, stdenv
<<<<<<< HEAD
, aplpy
, astropy
, astropy-helpers
, buildPythonPackage
, casa-formats-io
, dask
, fetchPypi
, joblib
, pytest-astropy
, pytestCheckHook
, pythonOlder
, radio_beam
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "spectral-cube";
<<<<<<< HEAD
  version = "0.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Fr9PvUShi04z8SUsZE7zHuXZWg4rxt6gwSBb6lr2Pc=";
=======
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c0pp82wgl680w2vcwlrrz46sy83z1qs74w5bd691wg0512hv2jx";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

<<<<<<< HEAD
  propagatedBuildInputs = [
    astropy
    casa-formats-io
    radio_beam
    joblib
    dask
  ];

  nativeCheckInputs = [
    aplpy
    pytest-astropy
    pytestCheckHook
  ];
=======
  propagatedBuildInputs = [ astropy casa-formats-io radio_beam joblib six dask ];
  nativeCheckInputs = [ pytestCheckHook aplpy pytest-astropy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # On x86_darwin, this test fails with "Fatal Python error: Aborted"
  # when sandbox = true.
  disabledTestPaths = lib.optionals stdenv.isDarwin [
    "spectral_cube/tests/test_visualization.py"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "spectral_cube"
  ];

  meta = with lib; {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
=======
  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
