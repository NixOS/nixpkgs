{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  black,
  click,
  libcst,
  moreorless,
  tomlkit,
  trailrunner,
  typing-extensions,
  usort,

  # optional-dependencies
  pygls_2,
  ruff-api,

  # tests
  unittestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ufmt";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "ufmt";
    tag = "v${version}";
    hash = "sha256-/5sfawsBmsStCCdu4lIq2iL0zywrWAN+qW/t3h2UIu0=";
  };

  build-system = [ flit-core ];

  dependencies = [
    black
    click
    libcst
    moreorless
    tomlkit
    trailrunner
    typing-extensions
    usort
  ];

  optional-dependencies = {
    lsp = [ pygls_2 ];
    ruff = [ ruff-api ];
  };

  nativeCheckInputs = [
    unittestCheckHook
    versionCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "ufmt" ];

  meta = {
    description = "Safe, atomic formatting with black and usort";
    homepage = "https://github.com/omnilib/ufmt";
    changelog = "https://github.com/omnilib/ufmt/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ufmt";
  };
}
