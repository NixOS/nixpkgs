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
  cargo-pgrx_0_12_0_alpha_1 = generic {
    version = "0.12.0-alpha.1";
    hash = "sha256-0m9oaqjU42RYyttkTihADDrRMjr2WoK/8sInZALeHws=";
    cargoHash = "sha256-zYjqE7LZLnTaVxWAPWC1ncEjCMlrhy4THtgecB7wBYY=";
  };

  cargo-pgrx_0_12_6 = generic {
    version = "0.12.6";
    hash = "sha256-7aQkrApALZe6EoQGVShGBj0UIATnfOy2DytFj9IWdEA=";
    cargoHash = "sha256-pnMxWWfvr1/AEp8DvG4awig8zjdHizJHoZ5RJA8CL08=";
  };

  cargo-pgrx_0_14_1 = generic {
    version = "0.14.1";
    hash = "sha256-oMToAhKkRiCyC8JYS0gmo/XX3QVcVtF5mUV0aQjd+p8=";
    cargoHash = "sha256-RawGAQGtG2QVDCMbwjmUEaH6rDeRiBvvJsGCY8wySw0=";
  };

  # Default version for direct usage.
  # Not to be used with buildPgrxExtension, where it should be pinned.
  # When you make an extension use the latest version, *copy* this to a separate pinned attribute.
  cargo-pgrx = generic {
    version = "0.15.0";
    hash = "sha256-sksRfNV6l8YbdI6fzrEtanpDVV4sh14JXLqYBydHwy0=";
    cargoHash = "sha256-c+n1bJMO9254kT4e6exVNhlIouzkkzrRIOVzR9lZeg4=";
  };
}
