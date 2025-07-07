{
  fetchFromGitHub,
  lib,
  libkrb5,
  openssl,
  postgresql,
  postgresqlBuildExtension,
}:

let
  sources = {
    # v18: No upstream ticket, yet (2025-07-07)
    "17" = {
      version = "17.1";
      hash = "sha256-9St/ESPiFq2NiPKqbwHLwkIyATKUkOGxFcUrWgT+Iqo=";
    };
    "16" = {
      version = "16.1";
      hash = "sha256-fzoAcXEKmA+xD4HtcHZgcduh1XmSgL8ZS4R72og7RGQ=";
    };
    "15" = {
      version = "1.7.1";
      hash = "sha256-emwoTowT7WKFX0RQDqJXjIblrzqaUIUkzqSqBCHVKQ8=";
    };
    "14" = {
      version = "1.6.2";
      hash = "sha256-Bl7Jk2B0deZUDiI391vk4nilwuVGHd1wuaQRSCoA3Mk=";
    };
    "13" = {
      version = "1.5.2";
      hash = "sha256-fyf2Ym0fAAXjc28iFCGDEftPAyDLXmEgi/0DaTJJiIg=";
    };
  };

  source =
    sources.${lib.versions.major postgresql.version} or {
      version = "";
      hash = throw "Source for pgaudit is not available for ${postgresql.version}";
    };
in
postgresqlBuildExtension {
  pname = "pgaudit";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "pgaudit";
    repo = "pgaudit";
    tag = source.version;
    inherit (source) hash;
  };

  buildInputs = [
    libkrb5
    openssl
  ];

  makeFlags = [ "USE_PGXS=1" ];

  enableUpdateScript = false;

  meta = {
    broken = !builtins.elem (lib.versions.major postgresql.version) (builtins.attrNames sources);
    description = "Open Source PostgreSQL Audit Logging";
    homepage = "https://github.com/pgaudit/pgaudit";
    changelog = "https://github.com/pgaudit/pgaudit/releases/tag/${source.version}";
    maintainers = with lib.maintainers; [ idontgetoutmuch ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
