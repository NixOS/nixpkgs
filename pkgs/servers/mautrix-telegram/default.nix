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
        version = "1.27.0a1";
        pname = "tulir-telethon";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-tABAY4UlTyMK1ZafIFawegjBAtcnq3HMNbE1L6WaT3E=";
        };
        doCheck = false;
      });
    };
  };
in python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.12.2";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "v${version}";
    sha256 = "sha256-htCk0VLr6GfXbpYWF/2bmpko7gSVlkH6HwDjOMhW8is=";
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
