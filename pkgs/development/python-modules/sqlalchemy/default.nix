{ lib
, fetchPypi
, buildPythonPackage
, pytest
, mock
, pytest_xdist
, isPy3k
, pysqlite
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  name = "${pname}-${version}";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lh9v10yrrz0prnqjf6hhgb5z23qicksq1dn2c76643byix515v9";
  };

  checkInputs = [
    pytest
    mock
#     Disable pytest_xdist tests for now, because our version seems to be too new.
#     pytest_xdist
  ] ++ lib.optional (!isPy3k) pysqlite;

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}