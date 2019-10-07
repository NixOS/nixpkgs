{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, pandas
, astropy
, parfive
, pythonOlder
, sqlalchemy
, scikitimage
, glymur
, beautifulsoup4
, drms
, python-dateutil
, zeep
, tqdm
, asdf
, astropy-helpers
, hypothesis
, pytest-astropy
, pytestcov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "sunpy";
  version = "1.0.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z5j9b7sa4cw3hikhg9ng0w6z8vr3xshpq5s9f36wdg8lx6zaha0";
  };

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

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    pytest sunpy -k "not test_rotation and not README"
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = https://sunpy.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
