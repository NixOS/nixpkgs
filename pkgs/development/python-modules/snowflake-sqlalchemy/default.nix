{ buildPythonPackage
, lib
, fetchPypi
, sqlalchemy
, snowflake-connector-python
}:

buildPythonPackage rec {
  pname = "snowflake-sqlalchemy";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1c087ce0a90bbce77f2308b9c4aeb14efeb26a3ae9da7c3d5a153341cd8ef34";
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
