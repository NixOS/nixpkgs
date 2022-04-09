{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigma-cli";
  version = "0.3.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FWcPHtEYqS+81dU4lB+4BLFOXtFumcyhucwvmu2TAt8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    prettytable
    pysigma
    pysigma-backend-splunk
    pysigma-pipeline-crowdstrike
    pysigma-pipeline-sysmon
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'prettytable = "^3.1.1"' 'prettytable = "*"'
  '';

  pythonImportsCheck = [
    "sigma.cli"
  ];

  meta = with lib; {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
