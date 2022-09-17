{ buildPythonPackage
, lib
, fetchPypi
, six
, snowflake-connector-python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dJK1biZ6rEpS4kTncfJzHjBLktDZSsqvSGekbmfhves=";
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
