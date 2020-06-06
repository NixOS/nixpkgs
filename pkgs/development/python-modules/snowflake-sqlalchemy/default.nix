{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.1.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c19890d94bc4e5b76e7ac1a3e4c9e2b49b4d95214156d140a781042b8389725";
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
