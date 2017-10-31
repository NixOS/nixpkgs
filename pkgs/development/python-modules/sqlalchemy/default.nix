{ lib
, fetchPypi
, buildPythonPackage
, pytest_30
, mock
, pytest_xdist
, isPy3k
, pysqlite
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  name = "${pname}-${version}";
  version = "1.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1191e29e35b6fe1aef7175a09b1707ebb7bd08d0b17cb0feada76c49e5a2d1e";
  };

  checkInputs = [
    pytest_30
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