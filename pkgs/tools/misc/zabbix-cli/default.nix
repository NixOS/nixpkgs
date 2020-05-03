{ fetchFromGitHub, lib, python2Packages }:
let
  pythonPackages = python2Packages;

in pythonPackages.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "2.2.1";

  propagatedBuildInputs = with pythonPackages; [ ipaddr requests ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "0wzmrn8p09ksqhhgawr179c4az7p2liqr0l4q2dra62bxliawyqz";
  };

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.womfoo ];
  };
}
