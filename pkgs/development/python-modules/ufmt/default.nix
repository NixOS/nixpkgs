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
  pygls,
  ruff-api,

  # tests
  unittestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ufmt";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "ufmt";
    tag = "v${version}";
    hash = "sha256-46H4oFuCC4BNONGWD4TU/HTNzc8+v8itUCXvDnsMxsk=";
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
    lsp = [ pygls ];
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
