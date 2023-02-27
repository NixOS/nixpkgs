{ lib
, python3
, fetchFromGitHub
, withE2BE ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.28.0a1";
        pname = "tulir-telethon";
        src = super.fetchPypi {
          inherit pname version;
          hash = "sha256-Kf7S5nSvedhA5RYt5rbTxBiQq6DGwHJ5uEYxd9AsYIc=";
        };
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonPackage {
  pname = "mautrix-telegram";
  version = "unstable-2023-02-16";
  disabled = python.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "354b49d9e5f91f913b5fdf9288bc631a9a34d142";
    hash = "sha256-zdK/0jgw++YwSzP8qs1BqInQlFOoM63TeI1jF1AqDnk=";
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
