{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = version;
    sha256 = "sha256-t8iVsdoJEHXtq9KK0WUGUX65zekKv8yzNoe8XgeeHd0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: option values must be strings
    "test_descriptor_del"
    "test_initialize"
  ];

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = "https://github.com/unioslo/zabbix-cli";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
