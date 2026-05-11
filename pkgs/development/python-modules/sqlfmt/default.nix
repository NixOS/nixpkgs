{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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

buildPythonPackage (finalAttrs: {
  pname = "sqlfmt";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/8BTH2nuqO+du6PsTPB59L21HvvAIZKDcG1kV9XHxsg=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "click" ];

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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    "tests/functional_tests/test_end_to_end.py"
    "tests/unit_tests/test_cli.py"
  ];

  meta = {
    description = "Formatter for dbt SQL files";
    homepage = "https://github.com/tconbeer/sqlfmt";
    changelog = "https://github.com/tconbeer/sqlfmt/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "sqlfmt";
  };
})
