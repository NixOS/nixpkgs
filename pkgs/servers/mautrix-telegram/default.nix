{ lib, python3, mautrix-telegram, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.25.0a3";
        pname = "tulir-telethon";
        src = oldAttrs.src.override {
          inherit pname version;
          sha256 = "sha256-/kau9Q2+7giVx52tmjvYIbcDcY1/om31X9BlRvZipuk=";
        };
      });
    };
  };

  # officially supported database drivers
  dbDrivers = with python.pkgs; [
    psycopg2
    aiosqlite
    # sqlite driver is already shipped with python by default
  ];

in python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.11.1";
  disabled = python.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "v${version}";
    sha256 = "sha256-Df+v1Q+5Iaa9GKcwIabMKjJwmVd5Qub8M54jEEiAPFc=";
  };

  patches = [ ./0001-Re-add-entrypoint.patch ];
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "telethon>=1.22,<1.23" "telethon"
  '';


  propagatedBuildInputs = with python.pkgs; ([
    Mako
    aiohttp
    mautrix
    sqlalchemy
    CommonMark
    ruamel-yaml
    python_magic
    tulir-telethon
    telethon-session-sqlalchemy
    pillow
    lxml
    setuptools
    prometheus-client
  ] ++ lib.optionals withE2BE [
    asyncpg
    python-olm
    pycryptodome
    unpaddedbase64
  ]) ++ dbDrivers;

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
    homepage = "https://github.com/mautrix/telegram";
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
