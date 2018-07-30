{ lib
, fetchPypi
, buildPythonPackage
, pytest
, mock
, isPy3k
, pysqlite
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72325e67fb85f6e9ad304c603d83626d1df684fdf0c7ab1f0352e71feeab69d8";
  };

  checkInputs = [
    pytest
    mock
#     Disable pytest_xdist tests for now, because our version seems to be too new.
#     pytest_xdist
  ] ++ lib.optional (!isPy3k) pysqlite;

  checkPhase = ''
    py.test -k "not test_round_trip_direct_type_affinity"
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}