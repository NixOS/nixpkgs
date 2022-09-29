{ buildPythonPackage
, lib
, fetchPypi
, six
, snowflake-connector-python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zKWDQSd8G1H+EFMYHHSVyAtJNxZ6+z1rkESi5dsVpVc=";
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
