{ lib, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d5156f205b94dbac76f7eafb0ca732ba16fa568d4440210f7dd4be5c3252dda";
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
