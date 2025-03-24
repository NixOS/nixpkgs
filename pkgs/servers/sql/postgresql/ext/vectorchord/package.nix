{
  buildPgrxExtension,
  cargo-pgrx_0_12_9,
  clang,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlTestExtension,
  replaceVars,
}:
let
  buildPgrxExtension' = buildPgrxExtension.override {
    cargo-pgrx = cargo-pgrx_0_12_9;
  };
in
buildPgrxExtension' (finalAttrs: {
  inherit postgresql;

  pname = "vectorchord";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "tensorchord";
    repo = "vectorchord";
    tag = finalAttrs.version;
    hash = "sha256-hZnB/c38PbJBcrd3N6N5IKkmcgG8NE0Xvxb0G5kbn1E=";
  };

  patches = [
    # Tell the `simd` crate to use the flags from the rust bindgen hook
    (replaceVars ./0001-read-clang-flags-from-environment.diff {
      clang = lib.getExe clang;
    })
    # Add feature flags needed for features not yet stabilised in rustc stable
    ./0002-add-feature-flags.diff
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-lob66NsflCAE14KBDp56PugkoisDSS4NWMRPBbBAmkA=";

  # Set appropriate version on vchord.control, otherwise it won't show up on PostgreSQL
  postPatch = ''
    substituteInPlace ./vchord.control --subst-var-by CARGO_VERSION ${finalAttrs.version}
  '';

  # Include upgrade scripts in the final package
  # https://github.com/tensorchord/VectorChord/blob/0.2.2/.github/workflows/release.yml#L85
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
      # buildPgrxExtension does not support overlay-like functions (finalAttrs)
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
      '';

      asserts = [
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
    description = "Scalable, fast, and disk-friendly vector search in Postgres, the successor of pgvecto.rs";
    homepage = "https://github.com/tensorchord/vectorchord";
    license = lib.licenses.agpl3Only; # dual licensed with Elastic License v2 (ELv2)
    maintainers = with lib.maintainers; [
      diogotcorreia
    ];
  };
})
