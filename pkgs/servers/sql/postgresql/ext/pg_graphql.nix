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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OnFYxhRBlEeCyRlgGu3N1rkKdsJoVyWnQF+kEqgAWhs=";
  };

  cargoHash = "sha256-EN1ndJwV0lQ7F0J2cTiiX+9MTgQnKJ+BWaq1lA8EPR4=";

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
