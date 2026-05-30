{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

lib.extendMkDerivation {
  constructDrv = rustPlatform.buildRustPackage;
  excludeDrvArgNames = [
    "version"
    "cargoHash"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      version,
      hash,
      cargoHash,
    }:
    {
      pname = "cargo-pgrx";

      inherit version;

      src = fetchCrate {
        inherit (finalAttrs)
          pname
          version
          ;
        inherit hash;
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
        "--skip=object_utils::tests::parses_managed_postmasters"
        # test name in versions < 0.18
        "--skip=command::schema::tests::test_parse_managed_postmasters"
      ];

      meta = {
        description = "Build Postgres Extensions with Rust";
        homepage = "https://github.com/pgcentralfoundation/pgrx";
        changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          happysalada
          matthiasbeyer
        ];
        mainProgram = "cargo-pgrx";
      };
    };
}
