{
  lib,
  buildPythonPackage,
  black,
  jinja2,
  dirty-equals,
  fastapi,
  fetchFromGitHub,
  pdm-backend,
  pydantic,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlmodel";
  version = "0.0.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    tag = finalAttrs.version;
    hash = "sha256-Ir0bWLdWF1h9Hr83QAbn5GiA9dh06Zrinltv54IKaM0=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    black
    jinja2
    dirty-equals
    fastapi
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlmodel" ];

  disabledTestPaths = [
    # Coverage
    "docs_src/tutorial/"
    "tests/test_tutorial/"
  ];

  meta = {
    description = "Module to work with SQL databases";
    homepage = "https://github.com/fastapi/sqlmodel";
    changelog = "https://github.com/fastapi/sqlmodel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
