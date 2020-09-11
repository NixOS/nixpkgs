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
  version = "0.8.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mhy9b933haz1bldkglvn81warjxdjdzgkviiv5k6fykghq473jf";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' requirements.txt
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

  checkInputs = [
    pytest
    pytestrunner
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
