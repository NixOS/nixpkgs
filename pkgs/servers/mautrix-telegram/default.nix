{ lib
, python3
, fetchPypi
, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.29.0a2";
        pname = "tulir-telethon";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-pTN8mJxbXvnhL11PCH/ZLeSqW0GV124Y3JnDcLek8JE=";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.14.1";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "refs/tags/v${version}";
    hash = "sha256-n3gO8R5lVl/8Tgo2tPzM64O2BRhoitsuPIC87bfxczc=";
  };

  format = "setuptools";

  patches = [ ./0001-Re-add-entrypoint.patch ];

  propagatedBuildInputs = with python.pkgs; ([
    ruamel-yaml
    python-magic
    commonmark
    aiohttp
    yarl
    mautrix
    tulir-telethon
    asyncpg
    mako
    setuptools
    # speedups
    cryptg
    aiodns
    brotli
    # qr_login
    pillow
    qrcode
    # formattednumbers
    phonenumbers
    # metrics
    prometheus-client
    # sqlite
    aiosqlite
    # proxy support
    pysocks
  ] ++ lib.optionals withE2BE [
    # e2be
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
