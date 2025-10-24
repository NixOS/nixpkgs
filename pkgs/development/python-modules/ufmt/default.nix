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

  # Broken since click was updated to 8.2.1 in https://github.com/NixOS/nixpkgs/pull/448189
  # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
  postPatch = ''
    substituteInPlace ufmt/tests/__init__.py \
      --replace-fail "from .cli import CliTest" ""
  '';

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
