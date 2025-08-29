{
  lib,
  runCommand,
  stdenv,
  stdenvNoCC,

  documentdb,
  postgresqlTestExtension,
}:

let
  runCommandWithExtensible =
    let
      # prevent infinite recursion for the default stdenv value
      defaultStdenv = stdenv;
    in
    {
      # which stdenv to use, defaults to a stdenv with a C compiler, pkgs.stdenv
      stdenv ? defaultStdenv,
      # whether to build this derivation locally instead of substituting
      runLocal ? false,
      # name of the resulting derivation
      name,
    }:
    lib.extendMkDerivation {
      constructDrv = stdenv.mkDerivation;

      excludeDrvArgNames = [
        "buildCommand"
        # "requiredExtensions"
      ];

      extendDrvArgs =
        finalAttrs:
        {
          buildCommand,
          ...
        }@prevAttrs:
        (
          {
            enableParallelBuilding = true;
            inherit buildCommand name;
            passAsFile = [ "buildCommand" ] ++ (prevAttrs.passAsFile or [ ]);
          }
          // lib.optionalAttrs (!prevAttrs ? meta) {
            pos =
              let
                args = builtins.attrNames prevAttrs;
              in
              if builtins.length args > 0 then builtins.unsafeGetAttrPos (builtins.head args) prevAttrs else null;
          }
          // (lib.optionalAttrs runLocal {
            preferLocalBuild = true;
            allowSubstitutes = false;
          })
          // builtins.removeAttrs prevAttrs [ "passAsFile" ]
        );
    };
  runCommandExtensible =
    name:
    runCommandWithExtensible {
      stdenv = stdenvNoCC;
      runLocal = false;
      inherit name;
    };
in
# wrap existing documentdb to avoid rebuilding
runCommandExtensible "documentdb_distributed" (finalAttrs: {
  pname = "documentdb_distributed";
  inherit (documentdb) version meta;

  buildCommand = ''
    ln -s ${documentdb} $out
  '';

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;

    # technically "works" without but will result in warnings
    #  WARNING:  transaction recovery cannot connect to localhost:5432
    env.postgresqlEnableTCP = 1;

    withPackages = documentdb.withPackages ++ [
      "citus"
    ];

    # pg_documentdb_distributed lib depends on SkipDocumentDBLoad symbol from pg_documentdb
    # also
    # "Note that pg_documentdb_distributed should be placed right after citus and pg_documentdb."
    # https://github.com/documentdb/documentdb/blob/4b0faabbe305ca7a369234ef07aa283c2b5b40db/internal/pg_documentdb_distributed/src/documentdb_distributed.c#L44C9-L44C98
    postgresqlExtraSettings = ''
      shared_preload_libraries='pg_cron, citus, pg_documentdb_core, pg_documentdb, pg_documentdb_distributed'
      cron.database_name = 'test_db'
    '';

    sql = ''
      -- not using CASCADE to stay aware of dependencies
      -- can cascade in NixOS VM test
      CREATE EXTENSION rum;
      CREATE EXTENSION pg_cron;
      CREATE EXTENSION tsm_system_rows;
      CREATE EXTENSION vector;
      CREATE EXTENSION postgis;
      CREATE EXTENSION citus;
      CREATE EXTENSION documentdb_core;
      CREATE EXTENSION documentdb;
      CREATE EXTENSION documentdb_distributed;

      SELECT citus_set_coordinator_host('localhost', 5432);
      SELECT citus_add_node('localhost', 5432);
      SELECT citus_set_node_property('localhost', 5432, 'shouldhaveshards', true);

      -- take snapshot of citus_tables before queries
      CREATE TABLE citus_tables_before AS SELECT * FROM citus_tables;

      SELECT documentdb_api.create_collection('documentdb','fruit');

      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F001", "name": "Apple", "tags": ["Crunchy", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F002", "name": "Orange", "tags": ["Peel", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F003", "name": "Peach", "tags": ["Fluffy", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F004", "name": "Kiwi", "tags": ["Hairy", "Sour"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F005", "name": "Blueberry", "tags": ["Small", "Sour", "Sweet"] }');

      SELECT collection FROM documentdb_api.collection('documentdb','fruit');
    '';
    asserts = [
      {
        query = "SELECT citus_is_coordinator()";
        expected = "true";
        description = "Citus was up";
      }
      {
        query = "SELECT count(*) FROM citus_tables_before";
        expected = "0";
        description = "Citus tables are readable and started empty";
      }
    ]
    ++ lib.optionals (finalAttrs.passthru.tests.extension.postgresqlEnableTCP == 1) [
      {
        query = "SELECT count(*) FROM citus_tables";
        expected = "4";
        description = "Citus tables were populated";
      }
    ];
  };
})
