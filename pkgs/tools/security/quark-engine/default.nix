{ lib
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quark-engine";
  version = "24.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cWO/avMz9nT9yo10b1ugC0C8NsEp2jAlcR0/+86gFKc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    androguard
    click
    colorama
    gitMinimal
    graphviz
    pandas
    plotly
    prettytable
    prompt-toolkit
    r2pipe
    rzpipe
    setuptools
    tqdm
  ];

  pythonRelaxDeps = [
    "r2pipe"
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "quark"
  ];

  meta = with lib; {
    description = "Android malware (analysis and scoring) system";
    homepage = "https://quark-engine.readthedocs.io/";
    changelog = "https://github.com/quark-engine/quark-engine/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
