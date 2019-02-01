{ lib, fetchpatch, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "mautrix-telegram";
  version = "0.4.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a51e55a7f362013ce1cce7d850c65dc8d4651dd05c63004429bc521b461d029";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/tulir/mautrix-telegram/commit/a258c59ca3558ad91b1fee190c624763ca835d2f.patch";
      sha256 = "04z4plsmqmg38rsw9irp5xc9wdgjvg6xba69mixi5v82h9lg3zzp";
    })

    ./fix_patch_conflicts.patch

    (fetchpatch {
      url = "https://github.com/tulir/mautrix-telegram/commit/8021fcc24cbf8c88d9bcb2601333863c9615bd4f.patch";
      sha256 = "0cdfv8ggnjdwdhls1lk6498b233lvnb6175xbxr206km5mxyvqyk";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    mautrix-appservice
    sqlalchemy
    alembic
    CommonMark
    ruamel_yaml
    future-fstrings
    python_magic
    telethon
    telethon-session-sqlalchemy
  ];

  # No tests available
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/tulir/mautrix-telegram;
    description = "A Matrix-Telegram hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
