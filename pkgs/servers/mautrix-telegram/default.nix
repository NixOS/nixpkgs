{ lib, python3, mautrix-telegram, fetchFromGitHub }:

with python3.pkgs;

let
  # officially supported database drivers
  dbDrivers = [
    psycopg2
    # sqlite driver is already shipped with python by default
  ];

in buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.9.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "1543ljjl3jg3ayid7ifi4bamqh4gq85pmlbs3m8i7phjbbm7g9dn";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' requirements.txt
  '';

  nativeBuildInputs = [
    pytestrunner
  ];

  propagatedBuildInputs = [
    Mako
    aiohttp
    mautrix
    sqlalchemy
    CommonMark
    ruamel_yaml
    python_magic
    telethon
    telethon-session-sqlalchemy
    pillow
    lxml
    setuptools
  ] ++ dbDrivers;

  # `alembic` (a database migration tool) is only needed for the initial setup,
  # and not needed during the actual runtime. However `alembic` requires `mautrix-telegram`
  # in its environment to create a database schema from all models.
  #
  # Hence we need to patch away `alembic` from `mautrix-telegram` and create an `alembic`
  # which has `mautrix-telegram` in its environment.
  passthru.alembic = alembic.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ dbDrivers ++ [
      mautrix-telegram
    ];
  });

  # Tests are broken and throw the following for every test:
  #   TypeError: 'Mock' object is not subscriptable
  doCheck = false;

  checkInputs = [
    pytest
    pytest-mock
    pytest-asyncio
  ];

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-telegram";
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
