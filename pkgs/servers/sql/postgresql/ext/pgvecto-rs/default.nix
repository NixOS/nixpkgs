{
  lib,
  buildPgrxExtension,
  cargo-pgrx_0_12_5,
  clang_16,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  postgresql,
  rustPlatform,
  stdenv,
}:

let
  # Upstream only works with clang 16, so we're pinning it here to
  # avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#set-up-development-environment, step 2
  clang = clang_16;
  rustPlatform' = rustPlatform // {
    bindgenHook = rustPlatform.bindgenHook.override { inherit clang; };
  };

in
(buildPgrxExtension.override {
  # Upstream only works with a fixed version of cargo-pgrx for each release,
  # so we're pinning it here to avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#set-up-development-environment, step 5
  cargo-pgrx = cargo-pgrx_0_12_5;
  rustPlatform = rustPlatform';
})
  rec {
    inherit postgresql;

    pname = "pgvecto-rs";
    version = "0.4.0";

    buildInputs = [ openssl ];
    nativeBuildInputs = [ pkg-config ];

    patches = [
      ./0001-add-rustc-feature-flags.diff
    ];

    src = fetchFromGitHub {
      owner = "tensorchord";
      repo = "pgvecto.rs";
      rev = "v${version}";
      hash = "sha256-4qrDWxYBJuQAtYlwU/zXVvX/ItqO26YAU/OHc/NLEUI=";
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-cyXKfkLju0hZe7IdNQ50AhhaEFtj795iaRutiQRuwZc=";

    # Set appropriate version on vectors.control, otherwise it won't show up on PostgreSQL
    postPatch = ''
      substituteInPlace ./vectors.control --subst-var-by CARGO_VERSION ${version}
    '';

    # Include upgrade scripts in the final package
    # https://github.com/tensorchord/pgvecto.rs/blob/v0.4.0/scripts/package.sh#L15
    postInstall = ''
      cp sql/upgrade/* $out/share/postgresql/extension/
    '';

    env = {
      # Needed to get openssl-sys to use pkg-config.
      OPENSSL_NO_VENDOR = 1;

      # Bypass rust nightly features not being available on rust stable
      RUSTC_BOOTSTRAP = 1;
    };

    # This crate does not have the "pg_test" feature
    usePgTestCheckFeature = false;

    passthru = {
      updateScript = nix-update-script { };
      tests = nixosTests.postgresql.pgvecto-rs.passthru.override postgresql;
    };

    meta = with lib; {
      # Upstream removed support for PostgreSQL 12 and 13 on 0.3.0: https://github.com/tensorchord/pgvecto.rs/issues/343
      broken = stdenv.hostPlatform.isDarwin || (versionOlder postgresql.version "14");
      description = "Scalable, Low-latency and Hybrid-enabled Vector Search in Postgres";
      homepage = "https://github.com/tensorchord/pgvecto.rs";
      license = licenses.asl20;
      maintainers = with maintainers; [
        diogotcorreia
        esclear
      ];
    };
  }
