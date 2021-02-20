{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, asdf
, astropy
, astropy-helpers
, astropy-extension-helpers
, beautifulsoup4
, drms
, glymur
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
  version = "2.0.7";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d13ac67c14ea825652dc3e12c4c627e782e8e843e96a1d54440d39dd2ceb6a5c";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    pandas
    astropy
    astropy-helpers
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
