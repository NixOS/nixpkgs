{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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

  patches = [
    # Fix click 8.2.x incompatibility
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    # https://github.com/omnilib/ufmt/pull/260
    (fetchpatch2 {
      name = "fix-click-incompatibility.patch";
      url = "https://github.com/omnilib/ufmt/pull/260/commits/7980d7cd0a29fbd287e10d939248ef7c9d38a660.patch";
      hash = "sha256-97/jQVGCC+PXk8uxyF/M7XlLuVqJ5SgQZd/MXkaiO70=";
    })
  ];

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
