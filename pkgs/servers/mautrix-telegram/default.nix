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
        version = "1.27.0a7";
        pname = "tulir-telethon";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-w4WILvLvJBKf3Nlj0omTCDDD4z+b0XFlCplQ/IHwIPs=";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "unstable-2023-01-28";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "f12abbe03846fd5897d58572ab24b70a58b337d2";
    sha256 = "sha256-5ZZ85FOmTO26q2zhAIsF7mTlN4BLNLW2dQF+0culkUM=";
  };

  format = "setuptools";

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
  ] ++ lib.optionals withHQthumbnails [
    # hq_thumbnails
    moviepy
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
