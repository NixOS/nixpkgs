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
  version = "1.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sBnkztxqTz7MQ0eYvkAvYWPojxBy6ek1qZxMppLTTM4=";
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
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://github.com/snowflakedb/snowflake-sqlalchemy";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
