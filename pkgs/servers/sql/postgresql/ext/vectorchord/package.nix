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
(buildPgrxExtension.override {
  # Upstream only works with a fixed version of cargo-pgrx for each release,
  # so we're pinning it here to avoid future incompatibility.
  cargo-pgrx = cargo-pgrx_0_12_9;
})
  rec {
    inherit postgresql;

    pname = "vectorchord";
    version = "0.2.2";

    src = fetchFromGitHub {
      owner = "tensorchord";
      repo = "vectorchord";
      tag = version;
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
      substituteInPlace ./vchord.control --subst-var-by CARGO_VERSION ${version}
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
        finalPackage = postgresql.pkgs.vectorchord;
        withPackages = [ "pgvector" ]; # vectorchord depends on pgvector at runtime
        postgresqlExtraSettings = ''
          shared_preload_libraries = 'vchord'
        '';

        sql = ''
          CREATE EXTENSION vector;
          CREATE EXTENSION vchord;

          CREATE TABLE items (embedding vector(3));
          INSERT INTO items (embedding) SELECT ARRAY[random(), random(), random()]::real[] FROM generate_series(1, 1000);

          CREATE INDEX ON items USING vchordrq (embedding vector_l2_ops) WITH (options = $$
          residual_quantization = true
          [build.internal]
          lists = [4096]
          spherical_centroids = false
          $$);
        '';
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
  }
