{ lib, python3, mautrix-telegram, fetchpatch }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lsi6x5yr8f9yjxsh1rmcd6wnxr6s6rpr720lg7sq629m42d9p1d";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/tulir/mautrix-telegram/commit/be6d395ed66d86ec7f13a262f9ae37731987019c.patch;
      sha256 = "1q69ip17r45yhyrxr0pj8bvqj2grw2l39wak8pi5pm7qrxra93j2";
    })
  ];

  disabled = pythonOlder "3.6";

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
