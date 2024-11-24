{
  lib,
  darwin,
  fetchCrate,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  generic =
    {
      version,
      hash,
      cargoHash,
    }:
    rustPlatform.buildRustPackage rec {
      pname = "cargo-pgrx";

      inherit version;

      src = fetchCrate {
        inherit version pname hash;
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

      meta = with lib; {
        description = "Build Postgres Extensions with Rust";
        homepage = "https://github.com/pgcentralfoundation/pgrx";
        changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${version}";
        license = licenses.mit;
        maintainers = with maintainers; [ happysalada ];
        mainProgram = "cargo-pgrx";
      };
    };
in
{
  cargo-pgrx_0_12_0_alpha_1 = generic {
    version = "0.12.0-alpha.1";
    hash = "sha256-0m9oaqjU42RYyttkTihADDrRMjr2WoK/8sInZALeHws=";
    cargoHash = "sha256-9XTIcpoCnROP63ZTDgMMMmj0kPggiTazKlKQfCgXKzk=";
  };

  cargo-pgrx_0_12_5 = generic {
    version = "0.12.5";
    hash = "sha256-U2kF+qjQwMTaocv5f4p5y3qmPUsTzdvAp8mz9cn/COw=";
    cargoHash = "sha256-nEgIOBGNG3TupA55/TgoXDPeJzjBjOGGfK+WjrH06VY=";
  };

  cargo-pgrx_0_12_6 = generic {
    version = "0.12.6";
    hash = "sha256-7aQkrApALZe6EoQGVShGBj0UIATnfOy2DytFj9IWdEA=";
    cargoHash = "sha256-Di4UldQwAt3xVyvgQT1gUhdvYUVp7n/a72pnX45kP0w=";
  };

}
