{ lib, python3, mautrix-telegram }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbed41838e1ef7e43f6e47ff38f9906cb311cfc5b3b6bc6f704babd7c83b193d";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' setup.py
  '';

  propagatedBuildInputs = [
    Mako
    aiohttp
    mautrix-appservice
    sqlalchemy
    CommonMark
    ruamel_yaml
    future-fstrings
    python_magic
    telethon
    telethon-session-sqlalchemy
    pillow
    lxml
    setuptools
  ];

  # `alembic` (a database migration tool) is only needed for the initial setup,
  # and not needed during the actual runtime. However `alembic` requires `mautrix-telegram`
  # in its environment to create a database schema from all models.
  #
  # Hence we need to patch away `alembic` from `mautrix-telegram` and create an `alembic`
  # which has `mautrix-telegram` in its environment.
  passthru.alembic = alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      mautrix-telegram
    ];
  });

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
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
