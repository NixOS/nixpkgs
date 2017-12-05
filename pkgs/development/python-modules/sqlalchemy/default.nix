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
  version = "1.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d501527319f51a3d9eb639b654222c6f67287228a98ba102b1d0b598eb3266c9";
  };

  checkInputs = [ pytest mock pytest_xdist ]
    ++ lib.optional (!isPy3k) pysqlite;

  # Test-only dependency pysqlite doesn't build on Python 3. This isn't an
  # acceptable reason to make all dependents unavailable on Python 3 as well
  #doCheck = !(isPyPy || isPy3k);

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}