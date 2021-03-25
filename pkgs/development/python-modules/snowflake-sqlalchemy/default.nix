{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e79d83d4947a0945488699324802eda4ad4a63c7680ad5b2a42c71f4faa2cd8b";
  };

  propagatedBuildInputs = [
    sqlalchemy
    snowflake-connector-python
  ];

  # Pypi does not include tests
  doCheck = false;
  pythonImportsCheck = [ "snowflake.sqlalchemy" ];

  meta = with lib; {
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://www.snowflake.net/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
