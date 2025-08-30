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
  version = "2025.08.07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "henryiii";
    repo = pname;
    tag = version;
    hash = "sha256-79aiRfw88QTYDllwAuQMYLHKUwwMwI2D5QPqgr4EItc=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    importlib-resources
  ];

  optional-dependencies = {
    all = [
      validate-pyproject
    ];
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
