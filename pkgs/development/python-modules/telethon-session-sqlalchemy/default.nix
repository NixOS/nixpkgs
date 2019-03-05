{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.9.post1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbe6a8ca32dd42aa1830b91f08f0458d728dc9eedca0ca27814a34c0b566100e";
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
