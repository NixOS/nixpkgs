{ lib
, buildPythonPackage
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
  version = "0.0.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    rev = "refs/tags/${version}";
    hash = "sha256-ER8NGDcCCCXT8lsm8fgJUaLyjdf5v2/UdrBw5T9EeXQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    fastapi
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlmodel"
  ];

  disabledTestPaths = [
    # Coverage
    "tests/test_tutorial/test_create_db_and_table/test_tutorial001.py"
  ];

  meta = with lib; {
    description = "Module to work with SQL databases";
    homepage = "https://github.com/tiangolo/sqlmodel";
    changelog = "https://github.com/tiangolo/sqlmodel/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
