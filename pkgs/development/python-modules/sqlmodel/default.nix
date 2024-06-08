{
  lib,
  buildPythonPackage,
  dirty-equals,
  fastapi,
  fetchFromGitHub,
  pdm-backend,
  pydantic,
  pytest-asyncio,
  pytest7CheckHook,
  pythonOlder,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlmodel";
  version = "0.0.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    rev = "refs/tags/${version}";
    hash = "sha256-2ens+wEFJThccBTBeBy8j1AzKJtebg3dJTGG6+Cpt+Q=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    dirty-equals
    fastapi
    pytest-asyncio
    pytest7CheckHook
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

  meta = with lib; {
    description = "Module to work with SQL databases";
    homepage = "https://github.com/tiangolo/sqlmodel";
    changelog = "https://github.com/tiangolo/sqlmodel/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
