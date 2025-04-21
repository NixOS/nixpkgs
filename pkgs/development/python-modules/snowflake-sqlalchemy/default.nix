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
    sha256 = "sha256-E3UnlsGaQPlxHSgBVGrG8pGCA8fE7yN5x9eidbMQ10w=";
  };

  dependencies = [
    six
    snowflake-connector-python
    sqlalchemy
  ];

  # tests are now available but seem broken in version 1.7.3
  doCheck = false;

  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
