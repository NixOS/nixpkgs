{ buildPythonPackage
, lib
, fetchPypi
, six
, snowflake-connector-python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9IooTfzXRmOE22huBSduM4kX8ltI6F50nvkUnXRkAFo=";
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
