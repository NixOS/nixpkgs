{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = "trueseeing";
    rev = "refs/tags/v${version}";
    hash = "sha256-5IHJXlpHZJFKj7rdmRsWA5FXZFJf3usGsLgXx1cYEmU=";
  };

  build-system = with python3.pkgs; [
    flit-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  dependencies = with python3.pkgs; [
    aiohttp
    asn1crypto
    attrs
    importlib-metadata
    jinja2
    lief
    lxml
    progressbar2
    pypubsub
    pyyaml
    termcolor
    zstandard
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "trueseeing"
  ];

  meta = with lib; {
    description = "Non-decompiling Android vulnerability scanner";
    homepage = "https://github.com/alterakey/trueseeing";
    changelog = "https://github.com/alterakey/trueseeing/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "trueseeing";
  };
}
