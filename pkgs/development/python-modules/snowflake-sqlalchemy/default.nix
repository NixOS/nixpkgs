{ buildPythonPackage
, lib
, fetchPypi
, six
, snowflake-connector-python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nXTPnWChj/rIMmPoVZr1AhY7tHVRygmpNmh1oGR6W4A=";
  };

  propagatedBuildInputs = [
    six
    snowflake-connector-python
    sqlalchemy
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
