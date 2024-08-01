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
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "ufmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-hIbzW7yDqk8siob+RhcnbOonkl+67sl/IGHimIeMM+Q=";
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

  passthru.optional-dependencies = {
    lsp = [ pygls ];
    ruff = [ ruff-api ];
  };

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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
