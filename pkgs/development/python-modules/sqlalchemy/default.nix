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
  version = "1.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76f76965e9a968ba3aecd2a8bc0d991cea04fd9a182e6c95c81f1551487b0211";
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