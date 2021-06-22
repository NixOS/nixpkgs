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
  version = "2.1.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df46101107b248577483d88e547badfc041dcbf6932bdc82004c4b3ee958baff";
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
    PY_IGNORE_IMPORTMISMATCH=1 HOME=$(mktemp -d) pytest sunpy -k 'not rst'
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
