{ lib
, buildPythonPackage
, fetchPypi
, six
, snowflake-connector-python
, sqlalchemy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xkx8QlabOCodqj4tRYxpln0z+HHVwYdqlXkaitzmKx8=";
  };

  propagatedBuildInputs = [
    six
    snowflake-connector-python
    sqlalchemy
  ];

  # Pypi does not include tests
  doCheck = false;

  pythonImportsCheck = [
    "snowflake.sqlalchemy"
  ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-sqlalchemy/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
