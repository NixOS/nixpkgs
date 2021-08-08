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
, pytest-cov
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
  version = "3.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WpqkCAwDYb6L+W4VTC/1auGVbblnNYwBxbk+tZbAiBw=";
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
    pytest-cov
    pytest-mock
  ];

  # darwin has write permission issues
  doCheck = stdenv.isLinux;

  # ignore documentation tests and ignore tests with schema issues
  checkPhase = ''
    PY_IGNORE_IMPORTMISMATCH=1 HOME=$(mktemp -d) pytest sunpy -k 'not rst' \
    --deselect=sunpy/tests/tests/test_self_test.py::test_main_nonexisting_module \
    --deselect=sunpy/tests/tests/test_self_test.py::test_main_stdlib_module \
    --ignore=sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/heliocentric-1.0.0.yaml \
    --ignore=sunpy/io/special/asdf/schemas/sunpy.org/sunpy/coordinates/frames/helioprojective-1.0.0.yaml
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
