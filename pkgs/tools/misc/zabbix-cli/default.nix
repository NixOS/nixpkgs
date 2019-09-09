{ fetchFromGitHub, lib, python2Packages }:
let
  pythonPackages = python2Packages;

in pythonPackages.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "2.1.1";

  propagatedBuildInputs = with pythonPackages; [ ipaddr requests ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "10a1cvjqwlqqfz52ajv9i53h6v95w8y7xmgqr79q2c4v1nz5bfks";
  };

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.womfoo ];
  };
}
