{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baboossh";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cybiere";
    repo = "baboossh";
    rev = "refs/tags/v${version}";
    hash = "sha256-E/a6dL6BpQ6D8v010d8/qav/fkxpCYNvSvoPAZsm0Hk=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    cmd2
    tabulate
    paramiko
    python-libnmap
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "baboossh"
  ];

  meta = with lib; {
    description = "Tool to do SSH spreading";
    homepage = "https://github.com/cybiere/baboossh";
    changelog = "https://github.com/cybiere/baboossh/releases/tag/v${version}";
    license = licenses.gpl3Only;
    mainProgram = "baboossh";
    maintainers = with maintainers; [ fab ];
  };
}
