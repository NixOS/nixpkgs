{ lib, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03dbd389e05aa08c52ef36ca362fcc9aa103f6c6173bb093ed03a96e05e8d43d";
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
