{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  snowflake-connector-python,
  sqlalchemy,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eRkew/6/syvP/s1m8qfdVhvVcTRepLzL9BzB+1wGgv8=";
  };

  propagatedBuildInputs = [
    six
    snowflake-connector-python
    sqlalchemy
  ];

  # Pypi does not include tests
  doCheck = false;

  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];

    # https://github.com/snowflakedb/snowflake-sqlalchemy/issues/380
    broken = versionAtLeast sqlalchemy.version "2";
  };
}
