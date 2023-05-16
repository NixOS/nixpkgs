{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
<<<<<<< HEAD
        version = "1.29.0a2";
        pname = "tulir-telethon";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-pTN8mJxbXvnhL11PCH/ZLeSqW0GV124Y3JnDcLek8JE=";
=======
        version = "1.28.0a3";
        pname = "tulir-telethon";
        src = super.fetchPypi {
          inherit pname version;
          hash = "sha256-N1XQGpjfyUqcT+bsSBxC5Purvnd/+4NzVzMhiaq5yDo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-n3gO8R5lVl/8Tgo2tPzM64O2BRhoitsuPIC87bfxczc=";
=======
    hash = "sha256-AfCo2uHOcSNCWXgrCLzJwl0Dj8n9Asdqm19wk0OeXgQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # proxy support
    pysocks
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
