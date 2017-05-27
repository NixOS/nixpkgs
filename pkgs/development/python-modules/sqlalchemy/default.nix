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
  version = "1.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dbd92b8af2306d600efa98ed36262d73aad227440a758c8dc3a067ca30096bd3";
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