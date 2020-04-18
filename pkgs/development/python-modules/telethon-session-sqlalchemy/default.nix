{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.15";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ba603d95d5be6ddecd8ecaeaffba00b75b49dd80eb77f6228dd7b793ca67fd2";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  # No tests available
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/telethon-session-sqlalchemy";
    description = "SQLAlchemy backend for Telethon session storage";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
