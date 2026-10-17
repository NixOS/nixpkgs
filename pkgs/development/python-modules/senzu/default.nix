{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  google-cloud-secret-manager,
  pydantic-settings,
  python-dotenv,
  rich,
  toml,
  typer,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "senzu";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NQogzZ5xgyhFKC3wjcrgmbmonQ2SIGBBRxC+hIHusm0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    google-cloud-secret-manager
    pydantic-settings
    python-dotenv
    rich
    toml
    typer
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "senzu" ];

  meta = {
    description = "Secret env sync for GCP teams";
    homepage = "https://github.com/philip-730/senzu";
    changelog = "https://github.com/philip-730/senzu/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philip-730 ];
    mainProgram = "senzu";
  };
})
