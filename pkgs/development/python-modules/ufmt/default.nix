{
  lib,
  black,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  flit-core,
  libcst,
  moreorless,
  pygls,
  pythonOlder,
  tomlkit,
  trailrunner,
  ruff-api,
  typing-extensions,
  unittestCheckHook,
  usort,
}:

buildPythonPackage rec {
  pname = "ufmt";
  version = "2.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "ufmt" ];

  meta = with lib; {
    description = "Safe, atomic formatting with black and usort";
    homepage = "https://github.com/omnilib/ufmt";
    changelog = "https://github.com/omnilib/ufmt/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ufmt";
  };
}
