{ lib
, fetchFromGitHub
, gitMinimal
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "quark-engine";
  version = "23.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-E9efhgMGN9lvMlFeZqo6xco75TtQsXULOzKX00pjqMM=";
  };

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
    rzpipe
    tqdm
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
