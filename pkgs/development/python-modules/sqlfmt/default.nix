{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  click,
  jinja2,
  platformdirs,
  tqdm,

  # optional-dependencies
  black,
  gitpython,

  # tests
  addBinToPathHook,
  pytest-asyncio,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "sqlfmt";
  version = "0.28.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    tag = "v${version}";
    hash = "sha256-9SO3G8SQOkxxSyro9dwSI6oH6BT8Rd66WqM5bvdVQkg=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "click"
  ];
  dependencies = [
    click
    jinja2
    platformdirs
    tqdm
  ];

  optional-dependencies = {
    jinjafmt = [ black ];
    sqlfmt_primer = [ gitpython ];
  };

  pythonImportsCheck = [ "sqlfmt" ];

  nativeCheckInputs = [
    addBinToPathHook
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    "tests/functional_tests/test_end_to_end.py"
    "tests/unit_tests/test_cli.py"
  ];

  meta = {
    description = "Sqlfmt formats your dbt SQL files so you don't have to";
    homepage = "https://github.com/tconbeer/sqlfmt";
    changelog = "https://github.com/tconbeer/sqlfmt/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "sqlfmt";
  };
}
