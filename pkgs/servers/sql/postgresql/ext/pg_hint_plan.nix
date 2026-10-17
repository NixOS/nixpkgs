{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

let
  sources = {
    "19" = {
      version = "1.9.0";
      hash = "sha256-q6pFczgTp98+OiJKV3AVt3DK5lhKLFz3GCILG57K7Rw=";
    };
    "18" = {
      version = "1.8.1";
      hash = "sha256-gUjOxq1LexasLJny2Y74ZmkKbJ7Jzb0dbETtRfnr8zc=";
    };
    "17" = {
      version = "1.7.2";
      hash = "sha256-ueC0Ml7d5eop/DbIUeUji9MblKvEtX3DDZ1dUefMMu4=";
    };
    "16" = {
      version = "1.6.3";
      hash = "sha256-QwQvSoOx0eeZMNIm1GMGUynuWCvwl5myFaY0/IBKWcc=";
    };
    "15" = {
      version = "1.5.4";
      hash = "sha256-YYdRc5XzhoEOA2M8bC4+DobDw1QMhLyDv2Li9X31pXY=";
    };
    "14" = {
      version = "1.4.5";
      hash = "sha256-HyFmdI1ozjaqgt6ni+T0+0DA08k/otlyZ0UP/Ex9YZw=";
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
