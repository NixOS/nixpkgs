{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = "refs/tags/${version}";
    sha256 = "sha256-i4dviSdrHNAn4mSWMn5DOBg4j8BXCfwKVYsDaBd/g6o=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
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
