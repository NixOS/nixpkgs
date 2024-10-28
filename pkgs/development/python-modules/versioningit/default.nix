{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  importlib-metadata,
  packaging,
  tomli,
  pytestCheckHook,
  build,
  hatchling,
  pydantic,
  pytest-cov-stub,
  pytest-mock,
  setuptools,
  git,
  mercurial,
}:

buildPythonPackage rec {
  pname = "versioningit";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tbg+2Z9WsH2DlAvuNEXKRsoSDRO2swTNtftE5apO3sA=";
  };

  build-system = [ hatchling ];

  dependencies =
    [ packaging ]
    ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ]
    ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # AttributeError: type object 'CaseDetails' has no attribute 'model_validate_json'
  doCheck = lib.versionAtLeast pydantic.version "2";

  nativeCheckInputs = [
    pytestCheckHook
    build
    hatchling
    pydantic
    pytest-cov-stub
    pytest-mock
    setuptools
    git
    mercurial
  ];

  disabledTests = [
    # wants to write to the Nix store
    "test_editable_mode"
  ];

  pythonImportsCheck = [ "versioningit" ];

  meta = with lib; {
    description = "setuptools plugin for determining package version from VCS";
    mainProgram = "versioningit";
    homepage = "https://github.com/jwodder/versioningit";
    changelog = "https://versioningit.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
