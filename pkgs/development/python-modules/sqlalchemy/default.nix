{ lib, fetchPypi, buildPythonPackage, isPy3k, isPy35
, mock
, pysqlite
, pytest
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "106digcgx7nwvykdvmnwf3vfxvfkdv6ykwk7sd325afklikgb3rg";
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
