{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15pyx8bdy6p5kjc0ldykzp0lwr3wqbhf16258yvlzfwm0hm3cvb9";
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
