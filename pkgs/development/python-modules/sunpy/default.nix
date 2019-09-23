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
  version = "1.0.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dmfzxxsjjax9wf2ljyl4z07pxbshrj828zi5qnsa9rgk4148q9x";
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
    pytest sunpy -k "not test_rotation"
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = https://sunpy.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
