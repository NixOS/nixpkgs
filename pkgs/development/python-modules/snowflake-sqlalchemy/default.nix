{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7c220db11c1abf3df67177fbcf0ea58d33d8531963f2d5df5f09fdac09b912f";
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
