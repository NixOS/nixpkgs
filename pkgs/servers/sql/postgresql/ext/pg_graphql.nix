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
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fQJumk5P9C6NqyS2FmUFeOS24Rp89upyVUyyT87pPOg=";
  };

  cargoHash = "sha256-Gmsa6drTwtEhAZuXYaA6MlhFoGP9NM8877teGQ72nuM=";

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
  };
})
