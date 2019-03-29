{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.14";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "94aaf98afc051b4e167783f3d972bd9b51ab736a1e45df100bf52984e53eebac";
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
