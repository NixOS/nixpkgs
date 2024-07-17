{
  lib,
  buildPgrxExtension,
  cargo-pgrx_0_11_2,
  clang_16,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  postgresql,
  rustPlatform,
  stdenv,
  substituteAll,
}:

let
  # Upstream only works with clang 16, so we're pinning it here to
  # avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#environment, step 4
  clang = clang_16;
  rustPlatform' = rustPlatform // {
    bindgenHook = rustPlatform.bindgenHook.override { inherit clang; };
  };

in
(buildPgrxExtension.override {
  # Upstream only works with a fixed version of cargo-pgrx for each release,
  # so we're pinning it here to avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#environment, step 6
  cargo-pgrx = cargo-pgrx_0_11_2;
  rustPlatform = rustPlatform';
})
  rec {
    inherit postgresql;

    pname = "pgvecto-rs";
    version = "0.2.1";

    buildInputs = [ openssl ];
    nativeBuildInputs = [ pkg-config ];

    patches = [
      # Tell the `c` crate to use the flags from the rust bindgen hook
      (substituteAll {
        src = ./0001-read-clang-flags-from-environment.diff;
        clang = lib.getExe clang;
      })
      # Fix build failure on rustc 1.78 due to missing feature flag.
      # Can (likely) be removed when pgvecto-rs 0.3.0 is released.
      # See https://github.com/NixOS/nixpkgs/issues/320131
      ./0002-std-detect-use-upstream.diff
    ];

    src = fetchFromGitHub {
      owner = "tensorchord";
      repo = "pgvecto.rs";
      rev = "v${version}";
      hash = "sha256-kwaGHerEVh6Oxb9jQupSapm7CsKl5CoH6jCv+zbi4FE=";
    };

    # Package has git dependencies on Cargo.lock (instead of just crate.io dependencies),
    # so cargoHash does not work, therefore we have to include Cargo.lock in nixpkgs.
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "openai_api_rust-0.1.8" = "sha256-os5Y8KIWXJEYEcNzzT57wFPpEXdZ2Uy9W3j5+hJhhR4=";
        "std_detect-0.1.5" = "sha256-Rsy8N0pTJ/3AIHjRyeOeyY7Q9Ho46ZcDmJFurCbRxiQ=";
      };
    };

    # Set appropriate version on vectors.control, otherwise it won't show up on PostgreSQL
    postPatch = ''
      substituteInPlace ./vectors.control --subst-var-by CARGO_VERSION ${version}
    '';

    # Include upgrade scripts in the final package
    # https://github.com/tensorchord/pgvecto.rs/blob/v0.2.0/scripts/ci_package.sh#L6-L8
    postInstall = ''
      cp sql/upgrade/* $out/share/postgresql/extension/
    '';

    env = {
      # Needed to get openssl-sys to use pkg-config.
      OPENSSL_NO_VENDOR = 1;

      # Bypass rust nightly features not being available on rust stable
      RUSTC_BOOTSTRAP = 1;
    };

    passthru = {
      updateScript = nix-update-script { };
      tests = {
        pgvecto-rs = nixosTests.pgvecto-rs;
      };
    };

    meta = with lib; {
      # The pgrx 0.11.2 dependency is broken in aarch64-linux: https://github.com/pgcentralfoundation/pgrx/issues/1429
      # It is fixed in pgrx 0.11.3, but upstream is still using pgrx 0.11.2
      # Additionally, upstream (accidentally) broke support for PostgreSQL 12 and 13 on 0.2.1, but
      # they are removing it in 0.3.0 either way: https://github.com/tensorchord/pgvecto.rs/issues/343
      broken =
        (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin || (versionOlder postgresql.version "14");
      description = "Scalable, Low-latency and Hybrid-enabled Vector Search in Postgres";
      homepage = "https://github.com/tensorchord/pgvecto.rs";
      license = licenses.asl20;
      maintainers = with maintainers; [
        diogotcorreia
        esclear
      ];
    };
  }
