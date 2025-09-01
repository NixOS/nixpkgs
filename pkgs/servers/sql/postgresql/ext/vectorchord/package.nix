{
  buildPgrxExtension,
  cargo-pgrx_0_14_1,
  clang,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlTestExtension,
  replaceVars,
  rust-jemalloc-sys,
  stdenv,
}:
let
  # Follow upstream and use rust-jemalloc-sys on linux aarch64 and x86_64
  # Additionally, disable init exec TLS, since it causes issues with postgres.
  # https://github.com/tensorchord/VectorChord/blob/0.4.2/Cargo.toml#L43-L44
  useSystemJemalloc =
    stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isx86_64);
  rust-jemalloc-sys' = (
    rust-jemalloc-sys.override (old: {
      jemalloc = old.jemalloc.override { disableInitExecTls = true; };
    })
  );
in
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_14_1;

  pname = "vectorchord";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tensorchord";
    repo = "vectorchord";
    tag = finalAttrs.version;
    hash = "sha256-EdMuSNcWwCBsAY0e3d0WVug1KBWYWldvKStF6cf/uRs=";
  };

  patches = [
    # Tell the `simd` crate to use the flags from the rust bindgen hook
    (replaceVars ./0001-read-clang-flags-from-environment.diff {
      clang = lib.getExe clang;
    })
    # Add feature flags needed for features not yet stabilised in rustc stable
    ./0002-add-feature-flags.diff
  ];

  buildInputs = lib.optionals useSystemJemalloc [
    rust-jemalloc-sys'
  ];

  cargoHash = "sha256-8NwfsJn5dnvog3fexzLmO3v7/3+L7xtv+PHWfCCWoHY=";

  # Include upgrade scripts in the final package
  # https://github.com/tensorchord/VectorChord/blob/0.4.2/crates/make/src/main.rs#L224
  postInstall = ''
    cp sql/upgrade/* $out/share/postgresql/extension/
  '';

  env = {
    # Bypass rust nightly features not being available on rust stable
    RUSTC_BOOTSTRAP = 1;
  };

  # This crate does not have the "pg_test" feature
  usePgTestCheckFeature = false;

  passthru = {
    updateScript = nix-update-script { };

    tests.extension = postgresqlTestExtension {
      inherit (finalAttrs) finalPackage;
      withPackages = [ "pgvector" ]; # vectorchord depends on pgvector at runtime
      postgresqlExtraSettings = ''
        shared_preload_libraries = 'vchord'
      '';

      sql = ''
        CREATE EXTENSION vchord CASCADE;

        CREATE TABLE items (id bigint PRIMARY KEY, embedding vector(3));
        INSERT INTO items (id, embedding) VALUES
        (1, '[1,2,4]'),
        (2, '[1,2,5]'),
        (3, '[0,0,3]'),
        (4, '[0,0,2]'),
        (5, '[0,0,1]');

        CREATE INDEX ON items USING vchordrq (embedding vector_l2_ops) WITH (options = $$
        residual_quantization = true
        [build.internal]
        lists = [4096]
        spherical_centroids = false
        $$);

        SET vchordrq.probes = 1;
      '';

      asserts = [
        {
          query = "SELECT extversion FROM pg_extension WHERE extname = 'vchord'";
          expected = "'${finalAttrs.version}'";
          description = "Expected installed version to match the derivation's version";
        }
        {
          query = "SELECT id FROM items WHERE embedding <-> '[1,2,3]' = 1";
          expected = "1";
          description = "Expected vector of row with ID=1 to have an euclidean distance from [1,2,3] of 1.";
        }
        {
          query = "SELECT id FROM items WHERE embedding <-> '[1,2,3]' = 2";
          expected = "2";
          description = "Expected vector of row with ID=2 to have an euclidean distance from [1,2,3] of 2.";
        }
        {
          query = "SELECT id FROM items ORDER BY embedding <-> '[2,3,7]' LIMIT 1";
          expected = "2";
          description = "Expected vector of row with ID=2 to be the closest to [2,3,7].";
        }
      ];
    };
  };

  meta = {
    # PostgreSQL 18 is not yet supported
    # Will be supported in the next release (likely 0.5.0), as it's already supported in the main branch
    # Check after next package update.
    broken = lib.warnIf (
      finalAttrs.version != "0.4.2"
    ) "Is postgresql18Packages.vectorchord still broken?" (lib.versionAtLeast postgresql.version "18");
    changelog = "https://github.com/tensorchord/VectorChord/releases/tag/${finalAttrs.version}";
    description = "Scalable, fast, and disk-friendly vector search in Postgres, the successor of pgvecto.rs";
    homepage = "https://github.com/tensorchord/VectorChord";
    license = lib.licenses.agpl3Only; # dual licensed with Elastic License v2 (ELv2)
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
    platforms = postgresql.meta.platforms;
  };
})
