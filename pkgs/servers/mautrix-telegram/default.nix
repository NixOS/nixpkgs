{ lib
, python3
, fetchFromGitHub
, withE2BE ? true
, withHQthumbnails ? false
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.26.0a5";
        pname = "tulir-telethon";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-s6pj9kHqcl6XU1KQ/aOw1XWQ3CyDotaDl0m7aj9SbW4=";
        };
        doCheck = false;
      });
    };
  };
in python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.12.1";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "v${version}";
    sha256 = "sha256-ecNcoNz++HtuDZnDLsXfPL0MRF+XMQ1BU/NFkKPbD5U=";
  };

  patches = [ ./0001-Re-add-entrypoint.patch ];

  propagatedBuildInputs = with python.pkgs; ([
    ruamel-yaml
    python-magic
    CommonMark
    aiohttp
    yarl
    mautrix
    tulir-telethon
    asyncpg
    Mako
    # optional
    cryptg
    cchardet
    aiodns
    brotli
    pillow
    qrcode
    phonenumbers
    prometheus-client
    aiosqlite
  ] ++ lib.optionals withHQthumbnails [
    moviepy
  ] ++ lib.optionals withE2BE [
    python-olm
    pycryptodome
    unpaddedbase64
  ]);

  # has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/telegram";
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ma27 nickcao ];
  };
}
