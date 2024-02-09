{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trueseeing";
  version = "2.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alterakey";
    repo = "trueseeing";
    rev = "refs/tags/v${version}";
    hash = "sha256-q7hUsBmTRPizmNWueFtFDc5t7rd1evMrBj3oX1Q2VfM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    flit-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    jinja2
    lxml
    pypubsub
    pyyaml
    termcolor
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
  };
}
