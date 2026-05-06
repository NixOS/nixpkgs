{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  importlib-resources,
  lib,
  pytestCheckHook,
  validate-pyproject,
}:

buildPythonPackage rec {
  pname = "validate-pyproject-schema-store";
  version = "2026.02.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "henryiii";
    repo = pname;
    tag = version;
    hash = "sha256-TZIRVAkDWbsjkQ3BifOEpgMU1attWWVStBsbMV1grHs=";
  };

  build-system = [
    hatchling
  ];

  optional-dependencies = {
    all = [
      validate-pyproject
    ]
    ++ validate-pyproject.optional-dependencies.all;
    validate-pyproject = [
      validate-pyproject
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [
    validate-pyproject
  ];
  pythonImportsCheck = [ "validate_pyproject_schema_store" ];

  meta = {
    description = "Weekly mirror of SchemaStore for validate-pyproject";
    homepage = "https://github.com/henryiii/validate-pyproject-schema-store";
    changelog = "https://github.com/henryiii/validate-pyproject-schema-store/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jemand771
    ];
  };
}
