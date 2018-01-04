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
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7dda3e0b1b12215e3bb05368d1abbf7d747112a43738e0a4e6deb466b83fd88e";
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