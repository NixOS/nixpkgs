{
  lib,
  buildPgrxExtension,
  cargo-pgrx_0_12_0_alpha_1,
  buildPackages,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  postgresql,
  rustPlatform,
  stdenv,
  replaceVars,
}:

let
  # Upstream only works with clang 16, so we're pinning it here to
  # avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#environment, step 4
  clang = buildPackages.clang_16;
  rustPlatform' = rustPlatform // {
    bindgenHook = rustPlatform.bindgenHook.override { inherit clang; };
  };

in
(buildPgrxExtension.override {
  # Upstream only works with a fixed version of cargo-pgrx for each release,
  # so we're pinning it here to avoid future incompatibility.
  # See https://docs.pgvecto.rs/developers/development.html#environment, step 6
  cargo-pgrx = cargo-pgrx_0_12_0_alpha_1;
  rustPlatform = rustPlatform';
})
  rec {
    inherit postgresql;

    pname = "pgvecto-rs";
    version = "0.3.0";

    buildInputs = [ openssl ];
    nativeBuildInputs = [ pkg-config ];

    patches = [
      # Tell the `c` crate to use the flags from the rust bindgen hook
      (replaceVars ./0001-read-clang-flags-from-environment.diff {
        clang = lib.getExe clang;
      })
    ];

    src = fetchFromGitHub {
      owner = "tensorchord";
      repo = "pgvecto.rs";
      rev = "v${version}";
      hash = "sha256-X7BY2Exv0xQNhsS/GA7GNvj9OeVDqVCd/k3lUkXtfgE=";
    };

    # Package has git dependencies on Cargo.lock (instead of just crate.io dependencies),
    # so cargoHash does not work, therefore we have to include Cargo.lock in nixpkgs.
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "pgrx-0.12.0-alpha.1" = "sha256-HSQrAR9DFJsi4ZF4hLiJ1sIy+M9Ygva2+WxeUzflOLk=";
        # https://github.com/pnkfelix/cee-scape/pull/27
        "cee-scape-0.2.0" = "sha256-hFGWthVN9vRE/QyscQb0N/T4W+EJxnMNCMIlYI0TMwA=";
      };
    };

    postUnpack = ''
      rm source/Cargo.lock
      cp ${./Cargo.lock} source/Cargo.lock
      chmod +w source/Cargo.lock
    '';

    postPatch =
      # Set appropriate version on vectors.control, otherwise it won't show up on PostgreSQL
      ''
        substituteInPlace ./vectors.control --subst-var-by CARGO_VERSION ${version}
      ''
      # https://github.com/jemalloc/jemalloc/pull/2812
      + (
        let
          patch = fetchpatch {
            name = "jemalloc-dep-shared-pthread.patch";
            url = "https://github.com/jemalloc/jemalloc/commit/86988bb5a8024854a91e27361b35af410019cdc4.patch";
            hash = "sha256-7ffCaniNx7mIridHbWcX2NOTCEb6S09pYr/lPGm1gV4=";
          };
        in
        ''
          for jemalloc in $(find .. -name jemalloc); do
            pushd $jemalloc
            if [[ -e src/background_thread.c ]]; then
              patch -p1 <${patch}
            fi
            popd
          done
        ''
      );

    # Include upgrade scripts in the final package
    # https://github.com/tensorchord/pgvecto.rs/blob/v0.2.0/scripts/ci_package.sh#L6-L8
    postInstall = ''
      cp sql/upgrade/* $out/share/postgresql/extension/
    '';

    env =
      {
        # Needed to get openssl-sys to use pkg-config.
        OPENSSL_NO_VENDOR = 1;

        # Bypass rust nightly features not being available on rust stable
        RUSTC_BOOTSTRAP = 1;

        "CC_${stdenv.buildPlatform.config}" =
          "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
      }
      // lib.optionalAttrs (stdenv.buildPlatform.config != stdenv.hostPlatform.config) {
        "CC_${stdenv.hostPlatform.config}" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
      };

    # This crate does not have the "pg_test" feature
    usePgTestCheckFeature = false;

    passthru = {
      updateScript = nix-update-script { };
      tests = nixosTests.postgresql.pgvecto-rs.passthru.override postgresql;
    };

    meta = with lib; {
      # Upstream removed support for PostgreSQL 13 on 0.3.0: https://github.com/tensorchord/pgvecto.rs/issues/343
      broken =
        (versionOlder postgresql.version "14")
        ||
          # PostgreSQL 17 support issue upstream: https://github.com/tensorchord/pgvecto.rs/issues/607
          # Check after next package update.
          versionAtLeast postgresql.version "17" && version == "0.3.0";
      description = "Scalable, Low-latency and Hybrid-enabled Vector Search in Postgres";
      homepage = "https://github.com/tensorchord/pgvecto.rs";
      license = licenses.asl20;
      maintainers = with maintainers; [
        diogotcorreia
        esclear
      ];
    };
  }
