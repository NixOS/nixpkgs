{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.7";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb83803c3ae17edc04030b375d1fc9ff1713796054f4ec8b7c0f1d0b6b21a8ed";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  # No tests available
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/tulir/telethon-session-sqlalchemy;
    description = "SQLAlchemy backend for Telethon session storage";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
