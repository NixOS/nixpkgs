{ lib, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51951845e52c4ca5410e0f4a51d99014dd6df2fcedfca8b7241e045359cbf112";
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
