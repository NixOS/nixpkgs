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
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "ufmt";
    tag = "v${version}";
    hash = "sha256-oEvvXUju7qne3pCwnrckplMs0kBJavB669qieXJZPKw=";
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);
  versionCheckProgramArg = "--version";

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
