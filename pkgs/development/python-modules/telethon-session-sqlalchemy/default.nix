{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.16";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f847c57302a102eb88e29ed95b8f4efa69582db2966fd806c21376b9a66ad4a8";
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
