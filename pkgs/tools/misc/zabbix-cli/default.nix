{ fetchFromGitHub, lib, python2Packages }:
let
  pythonPackages = python2Packages;

in pythonPackages.buildPythonApplication rec {
  name = "zabbix-cli-${version}";
  version = "2.0.1";

  propagatedBuildInputs = with pythonPackages; [ ipaddr requests ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "0kwrfgq6h26dajll11f21c8b799bsfl1axmk2fdghl1gclxra7ry";
  };

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.womfoo ];
  };
}
