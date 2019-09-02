{ lib, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbed41838e1ef7e43f6e47ff38f9906cb311cfc5b3b6bc6f704babd7c83b193d";
  };

  propagatedBuildInputs = [
    aiohttp
    mautrix-appservice
    sqlalchemy
    alembic
    CommonMark
    ruamel_yaml
    future-fstrings
    python_magic
    telethon
    telethon-session-sqlalchemy
    pillow
    lxml
  ];

  checkInputs = [
    pytest
    pytestrunner
    pytest-mock
    pytest-asyncio
  ];

  meta = with lib; {
    homepage = https://github.com/tulir/mautrix-telegram;
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
