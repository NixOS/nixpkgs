{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  snowflake-connector-python,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-sqlalchemy";
    tag = "v${version}";
    hash = "sha256-HxETZOHGfVcjopnoi8h37qanJa4pbjAmBk08u7HLRvA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    snowflake-connector-python
    sqlalchemy
  ];

  # Tests require a database
  doCheck = false;

  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = {
    description = "Snowflake SQLAlchemy Dialect";
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/${src.tag}/DESCRIPTION.md";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
