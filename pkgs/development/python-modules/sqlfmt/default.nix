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
  version = "0.32.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GM+LS1jrt7cCjkjM5T/nJEVRBdTm0Jd4ib+SvCbTAdA=";
  };

  build-system = [ hatchling ];

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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # importlib.metadata.PackageNotFoundError: No package metadata was found for sqlfmt
  dontCheckPythonMetadata = true;

  meta = {
    description = "Formatter for dbt SQL files";
    homepage = "https://github.com/tconbeer/sqlfmt";
    changelog = "https://github.com/tconbeer/sqlfmt/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pcboy ];
    mainProgram = "sqlfmt";
  };
})
