{ fetchFromGitHub, lib, python2Packages }:
let
  pythonPackages = python2Packages;

in pythonPackages.buildPythonApplication rec {
  name = "zabbix-cli-${version}";
  version = "1.6.1";

  propagatedBuildInputs = with pythonPackages; [ argparse requests ];

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "17ip3s8ifgj264zwxrr857wk02xmzmlsjrr613mdhkgdwizqbcs3";
  };

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.womfoo ];
  };
}
