{ stdenv
, lib
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
