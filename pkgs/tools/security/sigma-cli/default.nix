{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigma-cli";
  version = "0.7.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Qqe9nJZfCb7xh93ERrV3XpqdtfeRECt7RDca9eQU3eQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '= "^' '= ">='
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    colorama
    prettytable
    pysigma
    pysigma-backend-elasticsearch
    pysigma-backend-insightidr
    pysigma-backend-opensearch
    pysigma-backend-qradar
    pysigma-backend-splunk
    pysigma-pipeline-crowdstrike
    pysigma-pipeline-sysmon
    pysigma-pipeline-windows
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_plugin_list"
    "test_plugin_list_filtered"
    "test_plugin_list_search"
    "test_plugin_install_notexisting"
    "test_plugin_install"
    "test_plugin_uninstall"
  ];

  pythonImportsCheck = [
    "sigma.cli"
  ];

  meta = with lib; {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "sigma";
  };
}
