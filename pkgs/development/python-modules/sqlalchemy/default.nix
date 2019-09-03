{ lib, fetchPypi, buildPythonPackage, isPy3k
, mock
, pysqlite
, pytest
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zxhabcgzspwrh9l7b68p57kqx4h664a1dp9xr8mi84r472pyzi1";
  };

  checkInputs = [
    pytest
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
