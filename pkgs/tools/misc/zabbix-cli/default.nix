{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "2.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = "refs/tags/${version}";
    sha256 = "sha256-B5t/vxCmPdRR9YKOc2htI57Kmk1ZrpwPUln4JoUrK6g=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    packaging
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
