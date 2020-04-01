{ lib, python3, mautrix-telegram }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.7.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yi4h37lhlpa095hzd0gwn1ifbycq8878kj5n2sjhw8kk6nblda9";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' setup.py
    substituteInPlace setup.py \
      --replace "telethon>=1.9,<1.10" "telethon~=1.9"
  '';

  propagatedBuildInputs = [
    Mako
    aiohttp
    mautrix
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
