{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pmmwkw29944zh044azwbc1gf4s04fm55920d9if2a3zpjm6c5d7";
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
