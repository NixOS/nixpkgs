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
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e9ec143e2e246f385cfb2de8daa89d2fa466279addcb7be9e102988fdf33d24";
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