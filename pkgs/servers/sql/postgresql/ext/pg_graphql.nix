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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DOmxdLuYlRoQRprN4tni6JyXZ3nWaEqVQU0DNSYRYTc=";
  };

  cargoHash = "sha256-pgwx8Axctd37J79nUTbCGp6g2PGiHdgt99pMqGGLmyA=";

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
