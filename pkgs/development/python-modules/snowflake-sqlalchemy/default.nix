{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  six,
  snowflake-connector-python,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.7.3";
  pyproject = true;
  build-system = [ hatchling ];

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-sqlalchemy";
    tag = "v${version}";
    hash = "sha256-E3UnlsGaQPlxHSgBVGrG8pGCA8fE7yN5x9eidbMQ10w=";
  };

  dependencies = [
    six
    snowflake-connector-python
    sqlalchemy
  ];

  # Tests require a database
  doCheck = false;

  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = with lib; {
    description = "Snowflake SQLAlchemy Dialect";
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/v${version}/DESCRIPTION.md";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
