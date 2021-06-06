{ lib, python3Packages }:

let
  pname = "rst2html5";
  version = "1.10.6";
  format = "wheel";
in python3Packages.buildPythonPackage {
  inherit pname version format;

  src = python3Packages.fetchPypi {
    inherit pname version format;
    sha256 = "sha256-jmToDFLQODqgTycBp2J8LyoJ1Zxho9w1VdhFMzvDFkg=";
  };

  propagatedBuildInputs = with python3Packages;
  [ docutils genshi pygments beautifulsoup4 ];

  meta = with lib;{
    homepage = "https://pypi.org/project/rst2html5/";
    description = "Converts ReSTructuredText to (X)HTML5";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
