{
  buildPgrxExtension,
  cargo-pgrx_0_19_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_19_0;

  pname = "pg_graphql";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qpAfou/shsLKyUmJsya/Zph9nhdtQwXOcXpqmsOnIw=";
  };

  cargoHash = "sha256-j22VUErDuNePK3Ut5bPDnSGpOpC+wSqqM/kJD+fASyQ=";

  # pgrx tests try to install the extension into postgresql nix store
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GraphQL support for PostgreSQL";
    homepage = "https://supabase.github.io/pg_graphql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ julm ];
    broken = lib.versionOlder postgresql.version "14";
  };
})
