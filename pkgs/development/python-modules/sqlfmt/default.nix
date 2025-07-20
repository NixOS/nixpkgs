{
  lib,
  black,
  buildPythonPackage,
  click,
  fetchFromGitHub,
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
  version = "0.26.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    tag = "v${version}";
    hash = "sha256-q0pkwuQY0iLzK+Lef6k62UxMKJy592RsJnSZnVYdMa8=";
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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
