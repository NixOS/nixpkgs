{
  buildPgrxExtension,
  cargo-pgrx_0_16_1,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_16_1;

  pname = "pg_graphql";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mJBxen6Gg1LbzIF+WKThrs+wPD01a6WjZ+AHrGdWL4Q=";
  };

  cargoHash = "sha256-GZjoHGqNhZOuMbHji1Y3xKmdJ1GB1KasT+47P2e83sU=";

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
