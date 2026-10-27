{
  curl,
  fetchFromGitHub,
  lib,
  lz4,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

let
  # "Our soft policy for Postgres version compatibility is to support Citus'
  # latest release with Postgres' 3 latest releases."
  # https://www.citusdata.com/updates/v12-0/#deprecated_features
  sources = {
    "18" = {
      version = "14.2.0";
      hash = "sha256-iJb+aUcTeN9BLil72/KG8jObU79Cmyl49UDz7iCUAMk=";
    };
    "17" = {
      version = "14.2.0";
      hash = "sha256-iJb+aUcTeN9BLil72/KG8jObU79Cmyl49UDz7iCUAMk=";
    };
    "16" = {
      version = "14.2.0";
      hash = "sha256-iJb+aUcTeN9BLil72/KG8jObU79Cmyl49UDz7iCUAMk=";
    };
    "15" = {
      version = "13.4.0";
      hash = "sha256-o3RFtOlkBvgFFfT1+BlTD6XbAOiSzBPaMi6/m8i7+9k=";
    };
  };

  source =
    sources.${lib.versions.major postgresql.version} or {
      version = "";
      hash = throw "Source for citus is not available for ${postgresql.version}";
    };
in
postgresqlBuildExtension (finalAttrs: {
  pname = "citus";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "citus";
    tag = "v${finalAttrs.version}";
    inherit (source) hash;
  };

  buildInputs = [
    curl
    lz4
  ];

  enableUpdateScript = false;

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    postgresqlExtraSettings = ''
      shared_preload_libraries=citus
    '';
    sql = ''
      CREATE EXTENSION citus;

      CREATE TABLE examples (
        id bigserial,
        shard_key int,
        PRIMARY KEY (id, shard_key)
      );

      SELECT create_distributed_table('examples', 'shard_key');

      INSERT INTO examples (shard_key) SELECT shard % 10 FROM generate_series(1,1000) shard;
    '';
    asserts = [
      {
        query = "SELECT count(*) FROM examples";
        expected = "1000";
        description = "Distributed table can be queried successfully.";
      }
    ];
  };

  meta = {
    broken = !builtins.elem (lib.versions.major postgresql.version) (builtins.attrNames sources);
    description = "Distributed PostgreSQL as an extension";
    homepage = "https://www.citusdata.com/";
    changelog = "https://github.com/citusdata/citus/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ anish ];
    inherit (postgresql.meta) platforms;
  };
})
