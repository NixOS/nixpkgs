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
  version = "1.7.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-sqlalchemy";
    tag = "v${version}";
    hash = "sha256-8Q4cqfldSilBpj/1/4u5HRUDT8fD9MPzVGcokYt0dJA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    snowflake-connector-python
    sqlalchemy
  ];

  # Tests require a database
  doCheck = false;

  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = with lib; {
    description = "Snowflake SQLAlchemy Dialect";
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/${src.tag}/DESCRIPTION.md";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
