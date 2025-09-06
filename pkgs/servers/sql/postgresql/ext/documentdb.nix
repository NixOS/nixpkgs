{
  lib,
  postgresqlBuildExtension,
  fetchFromGitHub,

  pkg-config,

  intelrdfpmath,
  libkrb5,
  mongoc,
  openssl,
  pcre2,

  rum,

  postgresqlTestExtension,
  postgresql,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "documentdb";
  # require https://github.com/microsoft/documentdb/pull/241 to build with current mongoc
  # also note some tags in CHANGELOG.md are marked (Unreleased)
  # see version in pg_documentdb/documentdb.control
  version = "0.108-0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "documentdb";
    repo = "documentdb";
    # update postPatch when moving to release tags
    rev = "4b0faabbe305ca7a369234ef07aa283c2b5b40db";
    hash = "sha256-tQ+f8iuZbTBarxbh0pS5x4MpR/BshQWesQsOvqvooL8=";
  };

  postPatch = ''
    patchShebangs scripts/generate_extension_version.sh
    substituteInPlace scripts/generate_extension_version.sh \
      --replace-fail 'GIT_VERSION="unknown"'        'GIT_VERSION="${finalAttrs.src.rev}"' \
      --replace-fail 'BUILD_VER=" buildId:unknown"' 'BUILD_VER=" buildId:nixpkgs"' \
      --replace-fail 'GIT_SHA=" sha:unknown"'       'GIT_SHA=" sha:${
        builtins.substring 0 7 finalAttrs.src.rev
      }"'
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    intelrdfpmath
    libkrb5
    mongoc
    openssl
    pcre2
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (
    lib.concatStringsSep " " [
      # src/types/pcre_regex.c:46:3: error: redefinition of typedef 'PcreData' is a C11 feature
      "-Wno-typedef-redefinition"
      # src/api_hooks.c:284:60: error: passing arguments to a function without a prototype is deprecated in all versions of C and is not supported in C23
      "-Wno-deprecated-non-prototype"
      # src/aggregation/bson_aggregation_pipeline.c:918:1: error: unused function 'CreateChangeStreamContinuationtVar'
      "-Wno-unused-function"
      # src/roaring_bitmaps/roaring.h:1107:5: error: static function 'printf' is used in an inline function with external linkage
      "-Wno-static-in-inline"
    ]
  );

  postInstall =
    let
      libName = "rum${stdenv.hostPlatform.extensions.library}";
    in
    ''
      ln -s ${lib.getLib rum}/lib/${libName} $out/lib/${libName}
    '';

  enableUpdateScript = false;
  # to be replaced with proper dependency declaration in the future
  # see discussion in https://github.com/NixOS/nixpkgs/pull/436566
  passthru.withPackages = [
    "rum"
    "pg_cron"
    "pgvector"
    "postgis"
  ];
  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;

    inherit (finalAttrs.passthru) withPackages;

    postgresqlExtraSettings = ''
      shared_preload_libraries='pg_cron, pg_documentdb_core, pg_documentdb'
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
      CREATE EXTENSION documentdb_core;
      CREATE EXTENSION documentdb;

      SELECT documentdb_api.create_collection('documentdb','fruit');

      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F001", "name": "Apple", "tags": ["Crunchy", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F002", "name": "Orange", "tags": ["Peel", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F003", "name": "Peach", "tags": ["Fluffy", "Sweet"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F004", "name": "Kiwi", "tags": ["Hairy", "Sour"] }');
      SELECT documentdb_api.insert_one('documentdb','fruit', '{ "fruit_id": "F005", "name": "Blueberry", "tags": ["Small", "Sour", "Sweet"] }');

      SELECT collection FROM documentdb_api.collection('documentdb','fruit');
    '';
    asserts = [
      # ERROR:  Collection function should have been simplified during planning. Collection function should be only used in a FROM clause
      # {
      #   query = "SELECT count(collection) FROM documentdb_api.collection('documentdb','fruit')";
      #   expected = "5";
      #   description = "documentdb can be queried successfully.";
      # }
      {
        query = "select documentdb_api.binary_version()";
        # replace ending - with .
        # for now trim `-unstable` onwards
        expected = "'${
          lib.replaceStrings [ "-" ] [ "." ] (
            builtins.elemAt (lib.splitString "-unstable" finalAttrs.version) 0
          )
        }'";
        description = "version reported matches.";
      }
      {
        # take any version, any gitref other than unknown, a short commit sha, and force buildId to nixpkgs
        query = ''
          SELECT
            array_length(REGEXP_MATCHES(
              binary_extended_version,
              '\d+\.\d+\.\d+(-\w+)* gitref: ((?!unknown)\w)* sha:[a-z0-9]{7} buildId:nixpkgs'
            ), 1)::BOOLEAN AS matches_regex
          FROM documentdb_api.binary_extended_version()
        '';
        expected = "true";
        description = "extended version output matches regex.";
      }
    ];
  };

  meta = {
    description = "Graph database extension for PostgreSQL";
    longDescription = ''
      DocumentDB is a MongoDB compatible open source document database built on
      PostgreSQL. It offers a native implementation of a document-oriented NoSQL
      database, enabling seamless CRUD (Create, Read, Update, Delete) operations
      on BSON(Binary JSON) data types within a PostgreSQL framework. Beyond
      basic operations, DocumentDB empowers users to execute complex workloads,
      including full-text searches, geospatial queries, and vector search,
      delivering robust functionality and flexibility for diverse data
      management needs.
    '';
    homepage = "https://documentdb.io/";
    downloadPage = "https://github.com/documentdb/documentdb/";
    changelog = "https://github.com/documentdb/documentdb/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      jk
    ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
