{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, asdf
, astropy
, setuptools-scm
, astropy-helpers
, astropy-extension-helpers
, beautifulsoup4
, drms
, glymur
, h5netcdf
, hypothesis
, matplotlib
, numpy
, pandas
, parfive
, pytest-astropy
, pytest-mock
, pytestcov
, python-dateutil
, scikitimage
, scipy
, sqlalchemy
, towncrier
, tqdm
, zeep
}:

buildPythonPackage rec {
  pname = "sunpy";
  version = "3.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N/DAvnO+S9E4tndEWpiG84P3FCFwxYNdGFxbxUVsTx8=";
  };

  nativeBuildInputs = [
    setuptools-scm
    astropy-extension-helpers
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    pandas
    astropy
    astropy-helpers
    h5netcdf
    parfive
    sqlalchemy
    scikitimage
    towncrier
    glymur
    beautifulsoup4
    drms
    python-dateutil
    zeep
    tqdm
    asdf
  ];

  checkInputs = [
    hypothesis
    pytest-astropy
    pytestcov
    pytest-mock
  ];

  # darwin has write permission issues
  doCheck = stdenv.isLinux;

  # ignore documentation tests
  checkPhase = ''
    PY_IGNORE_IMPORTMISMATCH=1 HOME=$(mktemp -d) pytest sunpy -k 'not rst' \
    --deselect=sunpy/tests/tests/test_self_test.py::test_main_nonexisting_module \
    --deselect=sunpy/tests/tests/test_self_test.py::test_main_stdlib_module
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
