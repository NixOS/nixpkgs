{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b392096b14e5cdc4040d3900cc2be7847b160ed77e5c861a6bd07d75d8e17a85";
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
