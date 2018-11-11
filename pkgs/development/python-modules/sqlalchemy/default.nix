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
  version = "1.2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9de7c7dabcf06319becdb7e15099c44e5e34ba7062f9ba10bc00e562f5db3d04";
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