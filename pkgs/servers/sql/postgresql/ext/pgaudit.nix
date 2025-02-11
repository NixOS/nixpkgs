{
  lib,
  stdenv,
  fetchFromGitHub,
  libkrb5,
  openssl,
  postgresql,
  buildPostgresqlExtension,
}:

let
  source =
    {
      "17" = {
        version = "17.0";
        hash = "sha256-3ksq09wiudQPuBQI3dhEQi8IkXKLVIsPFgBnwLiicro=";
      };
      "16" = {
        version = "16.0";
        hash = "sha256-8+tGOl1U5y9Zgu+9O5UDDE4bec4B0JC/BQ6GLhHzQzc=";
      };
      "15" = {
        version = "1.7.0";
        hash = "sha256-8pShPr4HJaJQPjW1iPJIpj3CutTx8Tgr+rOqoXtgCcw=";
      };
      "14" = {
        version = "1.6.2";
        hash = "sha256-Bl7Jk2B0deZUDiI391vk4nilwuVGHd1wuaQRSCoA3Mk=";
      };
      "13" = {
        version = "1.5.2";
        hash = "sha256-fyf2Ym0fAAXjc28iFCGDEftPAyDLXmEgi/0DaTJJiIg=";
      };
      "12" = {
        version = "1.4.3";
        hash = "sha256-c8/xUFIHalu2bMCs57DeylK0oW0VnQwmUCpdp+tYqk4=";
      };
    }
    .${lib.versions.major postgresql.version}
    or (throw "Source for pgaudit is not available for ${postgresql.version}");
in
buildPostgresqlExtension {
  pname = "pgaudit";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "pgaudit";
    repo = "pgaudit";
    rev = source.version;
    hash = source.hash;
  };

  buildInputs = [
    libkrb5
    openssl
  ];

  makeFlags = [ "USE_PGXS=1" ];

  enableUpdateScript = false;

  meta = with lib; {
    description = "Open Source PostgreSQL Audit Logging";
    homepage = "https://github.com/pgaudit/pgaudit";
    changelog = "https://github.com/pgaudit/pgaudit/releases/tag/${source.version}";
    maintainers = with maintainers; [ idontgetoutmuch ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
