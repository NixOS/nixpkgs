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
  version = "1.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LtmTsdAAQhxjaTj4qCUlFsvuTPn64S6jT9cFIxaNjZg=";
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
