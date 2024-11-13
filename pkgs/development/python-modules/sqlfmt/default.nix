{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchFromGitHub,
  importlib-metadata,
  black,
  poetry-core,
  click,
  jinja2,
  platformdirs,
  tomli,
  tqdm,
  gitpython,
}:

buildPythonPackage rec {
  pname = "sqlfmt";
  version = "0.23.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-kbluj29P1HwTaCYv1Myslak9s8FFm2e/eHdGgi3H4i0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    importlib-metadata
    jinja2
    platformdirs
    tomli
    tqdm
  ];

  optional-dependencies = {
    jinjafmt = [
      black
    ];
    sqlfmt_primer = [
      gitpython
    ];
  };

  pythonRelaxDeps = [
    "platformdirs"
  ];

  pythonImportsCheck = [
    "sqlfmt"
  ];

  meta = {
    description = "Sqlfmt formats your dbt SQL files so you don't have to";
    homepage = "https://github.com/tconbeer/sqlfmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "sqlfmt";
  };
}
