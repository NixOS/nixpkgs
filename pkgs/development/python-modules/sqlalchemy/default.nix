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
  version = "1.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sj8c3v2k4a9s1qpnzl3nj7gg08fx0jqyy7761bf1kjag7ijshc4";
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
