{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nXTPnWChj/rIMmPoVZr1AhY7tHVRygmpNmh1oGR6W4A=";
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
