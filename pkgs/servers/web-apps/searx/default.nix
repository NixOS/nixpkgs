{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "searx";
  version = "0.14.0";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "046xg6xcs1mxgahz7kwf3fsmwd99q3hhms6pdjlvyczidlfhpmxl";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'certifi==2017.11.5' 'certifi' \
      --replace 'flask==0.12.2' 'flask==0.12.*' \
      --replace 'flask-babel==0.11.2' 'flask-babel==0.11.*' \
      --replace 'lxml==4.1.1' 'lxml==4.1.*' \
      --replace 'idna==2.5' 'idna' \
      --replace 'pygments==2.1.3' 'pygments>=2.1,<3.0' \
      --replace 'pyopenssl==17.4.0' 'pyopenssl' \
      --replace 'python-dateutil==2.6.1' 'python-dateutil==2.6.*'
  '';

  propagatedBuildInputs = [
    pyyaml lxml grequests flaskbabel flask requests
    gevent speaklater Babel pytz dateutil pygments
    pyasn1 pyasn1-modules ndg-httpsclient certifi pysocks
  ];

  checkInputs = [
    splinter mock plone-testing robotsuite unittest2 selenium
  ];

  preCheck = ''
    rm tests/test_robot.py # A variable that is imported is commented out
    rm tests/unit/engines/pubmed.py
  '';

  meta = with lib; {
    homepage = https://github.com/asciimoo/searx;
    description = "A privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matejc fpletz ];
  };
}
