{
  buildPgrxExtension,
  cargo-pgrx_0_16_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_16_0;

  pname = "pg_graphql";
  version = "1.5.12-unstable-2025-09-01";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    # ToDo: 1.5.12 has not been tagged in Git yet, hence `rev` is used instead for now
    #tag = "v${finalAttrs.version}";
    rev = "bae1cb506d48d14ccf2b05f6a42331f3c9c71a76";
    hash = "sha256-aJPstwzizWzVIo1N/4CHKgJBJ7DJpRkrwYrzNL+z7zQ=";
  };

  cargoHash = "sha256-Gfvu6YY+pRGrcAXAgEIa1iZKLJlbkvMv0F3pg3X/CXQ=";

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
    broken =
      lib.versionOlder postgresql.version "14"
      || (
        # ToDo: check after next package update.
        lib.versionAtLeast postgresql.version "18"
        && (
          finalAttrs.version == "1.5.12-unstable-2025-09-01"
          || lib.warn "Is postgresql18Packages.pg_graphql still broken?" false
        )
      );
  };
})
