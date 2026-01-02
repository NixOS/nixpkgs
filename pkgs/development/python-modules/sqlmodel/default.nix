{
  lib,
  buildPythonPackage,

  # build-system
  pdm-backend,

  # dependencies
  pydantic,
  sqlalchemy,

  # tests
  black,
  dirty-equals,
  fastapi,
  fetchFromGitHub,
  jinja2,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlmodel";
  version = "0.0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    tag = version;
    hash = "sha256-HJ8we0gYySagUvs7NEKcwe9l7KEcqmJ8+CTW/rjBdME=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    black
    dirty-equals
    fastapi
    jinja2
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlmodel" ];

  disabledTests = [
    # AssertionError: assert 'enum_field VARCHAR(1)
    "test_sqlite_ddl_sql"
  ];

  disabledTestPaths = [
    # Coverage
    "docs_src/tutorial/"
    "tests/test_tutorial/"
  ];

  meta = {
    description = "Module to work with SQL databases";
    homepage = "https://github.com/tiangolo/sqlmodel";
    changelog = "https://github.com/tiangolo/sqlmodel/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
