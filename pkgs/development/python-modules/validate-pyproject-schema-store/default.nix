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
  version = "2025.06.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "henryiii";
    repo = pname;
    rev = version;
    hash = "sha256-KrKDUgs5FBmVJ9nzoiuVuVHdl53vmV46VCghj8BNAnU=";
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
