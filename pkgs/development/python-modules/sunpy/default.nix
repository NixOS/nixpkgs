{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

, asdf
, astropy
, astropy-helpers
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
  version = "1.0.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sunpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j2yfhfxgi95rig8cfp9lvszb7694gq90jvs0xrb472hwnzgh2sk";
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

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
    export HOME=$(mktemp -d)
  '';

  # darwin has write permission issues
  doCheck = stdenv.isLinux;
  # ignore documentation tests
  checkPhase = ''
    pytest sunpy -k 'not rst'
  '';

  meta = with lib; {
    description = "SunPy: Python for Solar Physics";
    homepage = "https://sunpy.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
