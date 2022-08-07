{ lib, python3, mautrix-telegram, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      asyncpg = super.asyncpg.overridePythonAttrs (oldAttrs: rec {
        version = "0.25.0";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-Y/jmppczsoVJfChVRko03mV/LMzSWurutQcYcuk4JUA=";
        };
      });
      mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.16.3";
        src = oldAttrs.src.override {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-OpHLh5pCzGooQ5yxAa0+85m/szAafV+l+OfipQcfLtU=";
        };
      });
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.25.0a7";
        pname = "tulir-telethon";
        src = oldAttrs.src.override {
          inherit pname version;
          sha256 = "sha256-+wHRrBluM0ejdHjIvSk28wOIfCfIyibBcmwG/ksbiac=";
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
  version = "0.11.3";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "v${version}";
    sha256 = "sha256-PfER/wqJ607w0xVrFZadzmxYyj72O10c2lIvCW7LT8Y=";
  };

  patches = [ ./0001-Re-add-entrypoint.patch ];

  propagatedBuildInputs = with python.pkgs; ([
    Mako
    aiohttp
    mautrix
    sqlalchemy
    CommonMark
    ruamel-yaml
    python-magic
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
