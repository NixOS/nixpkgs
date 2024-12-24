{
  lib,
  black,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  fetchPypi,
  gitpython,
  importlib-metadata,
  jinja2,
  platformdirs,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  tomli,
  tqdm,
}:

buildPythonPackage rec {
  pname = "sqlfmt";
  version = "0.23.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-kbluj29P1HwTaCYv1Myslak9s8FFm2e/eHdGgi3H4i0=";
  };

  pythonRelaxDeps = [ "platformdirs" ];

  build-system = [ poetry-core ];

  dependencies = [
    click
    importlib-metadata
    jinja2
    platformdirs
    tomli
    tqdm
  ];

  optional-dependencies = {
    jinjafmt = [ black ];
    sqlfmt_primer = [ gitpython ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "sqlfmt" ];

  meta = {
    description = "Sqlfmt formats your dbt SQL files so you don't have to";
    homepage = "https://github.com/tconbeer/sqlfmt";
    changelog = "https://github.com/tconbeer/sqlfmt/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "sqlfmt";
  };
}
