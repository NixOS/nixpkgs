{ lib, buildPythonPackage, fetchPypi, isPy3k, sqlalchemy }:

buildPythonPackage rec {
  pname = "telethon-session-sqlalchemy";
  version = "0.2.8";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5097b4fe103e377b719f1840e121d14dbae38c4b7c72634c7ba1f0ec05b20533";
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
