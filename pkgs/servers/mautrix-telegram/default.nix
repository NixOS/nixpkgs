{ lib, python3, mautrix-telegram, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ebbb777cbf9312359b897bf81ba00dae0f5cb69fba2a18265dcc18a6f5ef7519";
        };
      });
    };
  };

  # officially supported database drivers
  dbDrivers = with python.pkgs; [
    psycopg2
    # sqlite driver is already shipped with python by default
  ];

in python.pkgs.buildPythonPackage rec {
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


  propagatedBuildInputs = with python.pkgs; ([
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
  ]) ++ dbDrivers;

  # `alembic` (a database migration tool) is only needed for the initial setup,
  # and not needed during the actual runtime. However `alembic` requires `mautrix-telegram`
  # in its environment to create a database schema from all models.
  #
  # Hence we need to patch away `alembic` from `mautrix-telegram` and create an `alembic`
  # which has `mautrix-telegram` in its environment.
  passthru.alembic = python.pkgs.alembic.overrideAttrs (old: {
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
  checkInputs = with python.pkgs; [
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
