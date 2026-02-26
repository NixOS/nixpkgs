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
  version = "0.15.3-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "telegram";
    rev = "e8114ff5ad642446162618e9453d2195e9480e05";
    hash = "sha256-NDGPHDEqQ+/UTP+s5M6xFF5Wj/AWs8cx74CnvghL8to=";
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
