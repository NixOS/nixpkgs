{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

let
  sources = {
    # For v18, see https://github.com/ossc-db/pg_hint_plan/issues/224
    "17" = {
      version = "1.7.0";
      hash = "sha256-MNQMePDmGxC8OFIJuVJrhfgU566vkng00+tjeGpGKvs=";
    };
    "16" = {
      version = "1.6.0";
      hash = "sha256-lg7N0QblluTgtNo1tGZjirNJSyQXtcAEs9Jqd3zx0Sg=";
    };
    "15" = {
      version = "1.5.1";
      hash = "sha256-o8Hepf/Mc1ClRTLZ6PBdqU4jSdlz+ijVgl2vJKmIc6M=";
    };
    "14" = {
      version = "1.4.2";
      hash = "sha256-nGyKcNY57RdQdZKSaBPk2/YbT0Annz1ZevH0lKswdhA=";
    };
    "13" = {
      version = "1.3.9";
      hash = "sha256-KGcHDwk8CgNHPZARfLBfS8r7TRCP9LPjT+m4fNSnnW0=";
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
