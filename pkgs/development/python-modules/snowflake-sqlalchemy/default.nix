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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-sqlalchemy";
    tag = "v${version}";
    hash = "sha256-Pg6tIJ026HNKLcsGTNVVj9yJa4gSH1SUJYuI1AdSvQA=";
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
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
