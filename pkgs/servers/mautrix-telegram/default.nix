{ lib
, python3
, fetchFromGitHub
, withE2BE ? true
, withHQthumbnails ? false
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
        version = "1.25.0a20";
        pname = "tulir-telethon";
        src = oldAttrs.src.override {
          inherit pname version;
          sha256 = "sha256-X9oo+YCNMqQrJvQa/PIi9dFgaeQxbrlnwUJnwjRb6Jc=";
        };
      });
    };
  };
in python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.12.0";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "v${version}";
    sha256 = "sha256-SUwiRrTY8NgOGQ643prsm3ZklOlwX/59m/u1aewFuik=";
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
