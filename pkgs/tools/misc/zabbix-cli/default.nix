{ fetchFromGitHub, lib, python2Packages }:
let
  pythonPackages = python2Packages;

in pythonPackages.buildPythonApplication rec {
  name = "zabbix-cli-${version}";
  version = "1.7.0";

  propagatedBuildInputs = with pythonPackages; [ ipaddr requests ];

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "0z33mv8xk0h72rn0iz1qrrkyz63w6cln8d5hqqddcvkxwnq0z6kx";
  };

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.womfoo ];
  };
}
