{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c598ef37623ef4d035a827f1e84725b3239a47f4366417d089de88f72fc4ac9";
  };

  propagatedBuildInputs = [
    sqlalchemy
    snowflake-connector-python
  ];

  meta = with lib; {
    description = "Snowflake SQLAlchemy Dialect";
    homepage = "https://www.snowflake.net/";
    license = licenses.asl20;
  };
}
