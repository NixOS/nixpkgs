{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "atomic-operator";
  version = "0.8.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "swimlane";
    repo = pname;
    rev = version;
    hash = "sha256-fO8bvzeMdJVWlhpzdTmJo9mrT6iorsLqr/GPF9gvE70=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    certifi
    chardet
    charset-normalizer
    fire
    idna
    paramiko
    pick
    pypsrp
    pyyaml
    requests
    urllib3
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "atomic_operator"
  ];

  disabledTests = [
    # Tests require network access
    "test_download_of_atomic_red_team_repo"
    "test_setting_input_arguments"
    "test_config_parser"
  ];

  meta = with lib; {
    description = "Tool to execute Atomic Red Team tests (Atomics)";
    homepage = "https://www.atomic-operator.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
