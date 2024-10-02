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
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-g2ycfpsBFMh16pYVzCmde0mhQhhvAhH25i3LJTcG7Ac=";
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
