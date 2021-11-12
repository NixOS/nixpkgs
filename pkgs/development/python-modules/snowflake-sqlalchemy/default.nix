{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51d9d923ebbfefe392582f6e3d0faa83f52e5eb6f190607820e055318dd2d2f8";
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
