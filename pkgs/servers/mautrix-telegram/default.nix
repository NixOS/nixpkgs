{
  lib,
  python3,
  fetchPypi,
  fetchFromGitHub,
  withE2BE ? true,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      tulir-telethon = self.telethon.overridePythonAttrs (oldAttrs: rec {
        version = "1.99.0a6";
        pname = "tulir_telethon";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-ewqc6s5xXquZJTZVBsFmHeamBLDw6PnTSNcmTNKD0sk=";
        };
        patches = [ ];
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonPackage {
  pname = "mautrix-telegram";
  version = "0.15.3-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "280c74e9cdbb7f057f5778bb31843647cf39925d";
    hash = "sha256-SwJ7HrmvRV0zadV0hLdNZbG7lmvK3EoW+OeM7Xc/2tQ=";
  };

  format = "setuptools";

  patches = [ ./0001-Re-add-entrypoint.patch ];

  propagatedBuildInputs =
    with python.pkgs;
    (
      [
        ruamel-yaml
        python-magic
        commonmark
        aiohttp
        yarl
        (mautrix.override { withOlm = withE2BE; })
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
      ]
      ++ lib.optionals withE2BE [
        # e2be
        python-olm
        pycryptodome
        unpaddedbase64
        base58
      ]
    );

  # has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/mautrix/telegram";
    description = "Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nyanloutre
      nickcao
    ];
    mainProgram = "mautrix-telegram";
  };
}
