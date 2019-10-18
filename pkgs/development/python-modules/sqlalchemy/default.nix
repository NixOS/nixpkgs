{ lib, fetchPypi, buildPythonPackage, isPy3k, isPy35
, mock
, pysqlite
, pytest
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f0768b5db594517e1f5e1572c73d14cf295140756431270d89496dc13d5e46c";
  };

  checkInputs = [
    pytest
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  checkPhase = if isPy35 then ''
    pytest test -k 'not exception_persistent_flush_py3k'
  '' else ''
    pytest test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
