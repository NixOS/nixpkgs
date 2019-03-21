{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "searx";
  version = "0.15.0";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "05si0fn57z1g80l6003cs0ypag2m6zyi3dgsi06pvjp066xbrjvd";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'certifi==2017.11.5' 'certifi' \
      --replace 'flask==1.0.2' 'flask==1.0.*' \
      --replace 'flask-babel==0.11.2' 'flask-babel==0.11.*' \
      --replace 'lxml==4.2.3' 'lxml==4.2.*' \
      --replace 'idna==2.7' 'idna' \
      --replace 'pygments==2.1.3' 'pygments>=2.1,<3.0' \
      --replace 'pyopenssl==18.0.0' 'pyopenssl' \
      --replace 'python-dateutil==2.7.3' 'python-dateutil==2.7.*'
    substituteInPlace requirements-dev.txt \
      --replace 'plone.testing==5.0.0' 'plone.testing' \
      --replace 'pep8==1.7.1' 'pep8==1.7.*' \
      --replace 'splinter==0.7.5' 'splinter' \
      --replace 'selenium==3.5.0' 'selenium'
  '';

  propagatedBuildInputs = [
    pyyaml lxml grequests flaskbabel flask requests
    gevent speaklater Babel pytz dateutil pygments
    pyasn1 pyasn1-modules ndg-httpsclient certifi pysocks
  ];

  checkInputs = [
    Babel mock nose2 covCore pep8 plone-testing splinter
    unittest2 zope_testrunner selenium
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
