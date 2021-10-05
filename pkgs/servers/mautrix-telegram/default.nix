{ lib, python3, mautrix-telegram, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.10.4";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ffbc4e29eb56089539b408f8e4c12a5d5a5d11d7fe7d40f8c6279784c618b869";
        };
      });
      telethon = super.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.21.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-mTyDfvdFrd+XKifXv7oM5Riihj0aUOBzclW3ZNI+DvI=";
        };
      });
    };
  };

  # officially supported database drivers
  dbDrivers = with python.pkgs; [
    psycopg2
    # sqlite driver is already shipped with python by default
  ];

in with python.pkgs; buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.10.1";
  disabled = python.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1Dmc7WRlT2ivGkdrGDC1b44DE0ovQKfUR0gDiQE4h5c=";
  };

  patches = [ ./0001-Re-add-entrypoint.patch ./0002-Don-t-depend-on-pytest-runner.patch ];
  postPatch = ''
    sed -i -e '/alembic>/d' requirements.txt
    substituteInPlace requirements.txt \
      --replace "telethon>=1.22,<1.23" "telethon"
  '';

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
  ] ++ lib.optionals withE2BE [
    asyncpg
    python-olm
    pycryptodome
    unpaddedbase64
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
  #
  # The tests were touched the last time in 2019 and upstream CI doesn't even build
  # those, so it's safe to assume that this part of the software is abandoned.
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
