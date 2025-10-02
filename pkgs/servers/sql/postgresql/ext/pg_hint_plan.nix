{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

let
  sources = {
    "18" = {
      version = "1.8.0";
      hash = "sha256-QsDppGN5TE7CSii3mNmwqT/riNNjyRTJk6d6Xcf0JMw=";
    };
    "17" = {
      version = "1.7.1";
      hash = "sha256-9GKqyrNpi80I4WWIiRN8zeXBm5bkRuzOWrZVfpYOzag=";
    };
    "16" = {
      version = "1.6.2";
      hash = "sha256-WMmtnuGOvLwtiEmgHpYURC1k5NmkBiDg+PnQCIZp7Sk=";
    };
    "15" = {
      version = "1.5.3";
      hash = "sha256-jkU0zt1waPTdFrBLAxYNvlo+RwdhCtKQq7iqAuxthNA=";
    };
    "14" = {
      version = "1.4.4";
      hash = "sha256-8rJ4Ck0Axf9zKhOXaJ4EA/M783YZRLuWx+GMGccadVo=";
    };
    "13" = {
      version = "1.3.11";
      hash = "sha256-XTxCw1Uj6rVLcXJuHoT3RkEhdKVLGjOdR7rhFI8YJas=";
    };
  };

  source =
    sources.${lib.versions.major postgresql.version} or {
      version = "";
      hash = throw "Source for pg_hint_plan is not available for ${postgresql.version}";
    };
in
postgresqlBuildExtension {
  pname = "pg_hint_plan";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "ossc-db";
    repo = "pg_hint_plan";
    tag = "REL${lib.versions.major postgresql.version}_${
      builtins.replaceStrings [ "." ] [ "_" ] source.version
    }";
    inherit (source) hash;
  };

  postPatch = lib.optionalString (lib.versionOlder postgresql.version "14") ''
    # https://github.com/ossc-db/pg_hint_plan/commit/e9e564ad59b8bd4a03e0f13b95b5122712e573e6
    substituteInPlace Makefile --replace "LDFLAGS+=-Wl,--build-id" ""
  '';

  enableUpdateScript = false;

  meta = {
    broken = !builtins.elem (lib.versions.major postgresql.version) (builtins.attrNames sources);
    description = "Extension to tweak PostgreSQL execution plans using so-called 'hints' in SQL comments";
    homepage = "https://github.com/ossc-db/pg_hint_plan";
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd3;
  };
}
