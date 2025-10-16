{
  buildPgrxExtension,
  cargo-pgrx_0_16_0,
  fetchFromGitHub,
  lib,
  nix-update-script,
  postgresql,
  postgresqlTestExtension,
}:
buildPgrxExtension (finalAttrs: {
  inherit postgresql;
  cargo-pgrx = cargo-pgrx_0_16_0;

  pname = "vectorchord";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "tensorchord";
    repo = "vectorchord";
    tag = finalAttrs.version;
    hash = "sha256-+c1Uf/3rp+HuthDVPLloJF2MQPW3Xho897Z2eAnG6aM=";
  };

  cargoHash = "sha256-/EcQgQ6J9hg4BsniRX7OMwEYy5EtVeT6Q/+3mAkyCH8=";

  # Include upgrade scripts in the final package
  # https://github.com/tensorchord/VectorChord/blob/0.5.0/crates/make/src/main.rs#L366
  postInstall = ''
    cp sql/upgrade/* $out/share/postgresql/extension/
  '';

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
