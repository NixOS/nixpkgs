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
  version = "1.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a98ac87b30eaa2bee1f1044848b9590e476e7f93d033c6542e60b993a5cf898";
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