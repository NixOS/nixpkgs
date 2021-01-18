{ buildPythonPackage
, coveralls
, fetchFromGitHub
, flake8
, graphviz
, lib
, mock
, pytestCheckHook
, requests
, sphinx
, sphinx_rtd_theme
, toml
, xmltodict
}:

buildPythonPackage rec {
  pname = "soco";
  version = "0.20";

  # N.B. We fetch from GitHub because the PyPI tarball doesn't contain the
  # required files to run the tests.
  src = fetchFromGitHub {
    owner = "SoCo";
    repo = "SoCo";
    rev = "v${version}";
    sha256 = "0p87aw7wxgdjz0m0nqqcfvbn24hlbq1hh1zxdq2c0k2jcbmaj8zc";
  };

  # N.B. These exist because:
  # 1. Upstream's pinning isn't well maintained, leaving dependency versions no
  #    longer in nixpkgs.
  # 2. There is no benefit for us to be running linting and coverage tests.
  postPatch = ''
    sed -i "/black/d" ./requirements-dev.txt
    sed -i "/pylint/d" ./requirements-dev.txt
    sed -i "/pytest-cov/d" ./requirements-dev.txt
  '';

  propagatedBuildInputs = [
    requests
    toml
    xmltodict
  ];
  checkInputs = [
    pytestCheckHook
    coveralls
    flake8
    graphviz
    mock
    sphinx
    sphinx_rtd_theme
  ];

  meta = with lib; {
    homepage = "http://python-soco.com/";
    description = "A CLI and library to control Sonos speakers";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
