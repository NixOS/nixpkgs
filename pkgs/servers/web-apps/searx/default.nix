{ lib, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonApplication rec {
  pname = "searx";
  version = "0.13.1";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "searx";
    rev = "v${version}";
    sha256 = "0nizxq9ggf9g8f8pxn2hfm0kn20356v65h4cj9s73n742nkv6ani";
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

  checkInputs = [ splinter mock plone-testing robotsuite unittest2 ];

  preCheck = ''
    rm tests/test_robot.py # A variable that is imported is commented out
  '';

  meta = with lib; {
    homepage = https://github.com/asciimoo/searx;
    description = "A privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matejc fpletz profpatsch ];
  };
}
