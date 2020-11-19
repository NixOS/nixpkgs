{ lib, python3Packages, fetchFromGitHub, fetchpatch }:

with python3Packages;

buildPythonApplication rec {
  pname = "searx";
  version = "0.17.0";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "0pznz3wsaikl8khmzqvj05kzh5y07hjw8gqhy6x0lz1b00cn5af4";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
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
