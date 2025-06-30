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
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-sqlalchemy";
    tag = "v${version}";
    hash = "sha256-Twv8ugLrQT9y4wHNo0B8vkWOFNSci/t4eY9XvFlq/TE=";
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
