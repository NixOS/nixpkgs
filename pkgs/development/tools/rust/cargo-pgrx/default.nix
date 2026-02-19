{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

let
  generic =
    {
      version,
      hash,
      cargoHash,
    }:
    rustPlatform.buildRustPackage {
      pname = "cargo-pgrx";

      inherit version;

      src = fetchCrate {
        inherit version hash;
        pname = "cargo-pgrx";
      };

      inherit cargoHash;

      nativeBuildInputs = [
        pkg-config
      ];

      buildInputs = [
        openssl
      ];

      preCheck = ''
        export PGRX_HOME=$(mktemp -d)
      '';

      checkFlags = [
        # requires pgrx to be properly initialized with cargo pgrx init
        "--skip=command::schema::tests::test_parse_managed_postmasters"
      ];

      meta = {
        description = "Build Postgres Extensions with Rust";
        homepage = "https://github.com/pgcentralfoundation/pgrx";
        changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${version}";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          happysalada
          matthiasbeyer
        ];
        mainProgram = "cargo-pgrx";
      };
    };
in
{
  # Default version for direct usage.
  # Not to be used with buildPgrxExtension, where it should be pinned.
  # When you make an extension use the latest version, *copy* this to a separate pinned attribute.
  cargo-pgrx = generic {
    version = "0.17.0";
    hash = "sha256-Ld7m7ggxlf8FufpeiAE9qcu49X0SgX6XXHS6KIewGyA=";
    cargoHash = "sha256-hNj39YzJna8iZxnlrLz+uLduxaD+uvggQRM7ng3MN1k=";
  };
}
// lib.mapAttrs (_: generic) (import ./pinned.nix)
