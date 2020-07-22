{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, python
}:

buildPythonPackage rec {
  pname = "sqlalchemy-citext";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d66e7d49826fec28a9ce69053fdf82d3a5ff397968c5bf38a0d83dcb4bf2303";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  checkPhase = ''
    ${python.interpreter} tests/test_citext.py
  '';

  meta = with lib; {
    description = "A sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
