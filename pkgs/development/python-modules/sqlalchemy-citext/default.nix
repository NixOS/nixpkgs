{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, python
}:

buildPythonPackage rec {
  pname = "sqlalchemy-citext";
  version = "1.3-0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d7343037a35153d6f94c3c2f6baf391f88a57651c3bde5d6749d216859ae4c5";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  checkPhase = ''
    ${python.interpreter} tests/test_citext.py
  '';

  meta = with lib; {
    description = "A sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = https://github.com/mahmoudimus/sqlalchemy-citext;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
