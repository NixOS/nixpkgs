{ lib
, buildPythonPackage
, dirty-equals
, fastapi
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "sqlmodel";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    rev = "refs/tags/${version}";
    hash = "sha256-EEOS7c0ospo7qjqPQkKwYXeVmBR5DueONzmjspV6w7w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    dirty-equals
    fastapi
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlmodel"
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
