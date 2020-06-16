{ lib, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "searx";
  version = "0.16.0";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "0hfa4nmis98yvghxw866rzjpmhb2ln8l6l8g9yx4m79b2lk76xcs";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'certifi==2019.3.9' 'certifi' \
      --replace 'flask==1.0.2' 'flask' \
      --replace 'flask-babel==0.12.2' 'flask-babel' \
      --replace 'jinja2==2.10.1' 'jinja2' \
      --replace 'lxml==4.3.3' 'lxml' \
      --replace 'idna==2.8' 'idna' \
      --replace 'pygments==2.1.3' 'pygments>=2.1,<3.0' \
      --replace 'pyopenssl==19.0.0' 'pyopenssl' \
      --replace 'python-dateutil==2.8.0' 'python-dateutil==2.8.*' \
      --replace 'pyyaml==5.1' 'pyyaml' \
      --replace 'requests[socks]==2.22.0' 'requests[socks]'
    substituteInPlace requirements-dev.txt \
      --replace 'plone.testing==5.0.0' 'plone.testing' \
      --replace 'pep8==1.7.0' 'pep8==1.7.*' \
      --replace 'splinter==0.11.0' 'splinter' \
      --replace 'selenium==3.141.0' 'selenium'
  '';

  propagatedBuildInputs = [
    pyyaml lxml grequests flaskbabel flask requests
    gevent speaklater Babel pytz dateutil pygments
    pyasn1 pyasn1-modules ndg-httpsclient certifi pysocks
    jinja2
  ];

  checkInputs = [
    Babel mock nose2 covCore pep8 plone-testing splinter
    unittest2 zope_testrunner selenium
  ];

  preCheck = ''
    rm tests/test_robot.py # A variable that is imported is commented out
  '';

  meta = with lib; {
    homepage = "https://github.com/asciimoo/searx";
    description = "A privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matejc fpletz globin danielfullmer ];
  };
}
