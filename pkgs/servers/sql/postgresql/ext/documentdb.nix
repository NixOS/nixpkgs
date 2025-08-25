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

  postgresqlTestExtension,
  postgresql,
  stdenv,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "documentdb";
  # require https://github.com/microsoft/documentdb/pull/241 to build with current mongoc
  # also note some tags in CHANGELOG.md are marked (Unreleased)
  version = "0.106-0-unstable-2025-08-24";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "documentdb";
    rev = "9e414a7d1f9076bac64886db900947e17241b2ef";
    hash = "sha256-K+wdeJJy4IHNl1GCzB9KLBIvm7wlU/pW3jOpbugA3nM=";
  };

  postPatch = ''
    patchShebangs scripts
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

  enableUpdateScript = false;
  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;

    withPackages = [
      "rum"
      "pg_cron"
      "pgvector"
      "postgis"
    ];

    postgresqlExtraSettings = ''
      shared_preload_libraries='pg_cron,pg_documentdb_core,pg_documentdb'
      cron.database_name = 'test_db'
    '';

    sql = ''
      CREATE EXTENSION rum;
      CREATE EXTENSION pg_cron;
      CREATE EXTENSION tsm_system_rows;
      CREATE EXTENSION vector;
      CREATE EXTENSION postgis;
      CREATE EXTENSION documentdb_core;
      CREATE EXTENSION documentdb;

      SELECT documentdb_api.create_collection('documentdb','patient');

      select documentdb_api.insert_one('documentdb','patient', '{ "patient_id": "P001", "name": "Alice Smith", "age": 30, "phone_number": "555-0123", "registration_year": "2023","conditions": ["Diabetes", "Hypertension"]}');
      select documentdb_api.insert_one('documentdb','patient', '{ "patient_id": "P002", "name": "Bob Johnson", "age": 45, "phone_number": "555-0456", "registration_year": "2023", "conditions": ["Asthma"]}');
      select documentdb_api.insert_one('documentdb','patient', '{ "patient_id": "P003", "name": "Charlie Brown", "age": 29, "phone_number": "555-0789", "registration_year": "2024", "conditions": ["Allergy", "Anemia"]}');
      select documentdb_api.insert_one('documentdb','patient', '{ "patient_id": "P004", "name": "Diana Prince", "age": 40, "phone_number": "555-0987", "registration_year": "2024", "conditions": ["Migraine"]}');
      select documentdb_api.insert_one('documentdb','patient', '{ "patient_id": "P005", "name": "Edward Norton", "age": 55, "phone_number": "555-1111", "registration_year": "2025", "conditions": ["Hypertension", "Heart Disease"]}');

      SELECT collection FROM documentdb_api.collection('documentdb','patient')
    '';
    # ERROR:  Collection function should have been simplified during planning. Collection function should be only used in a FROM clause
    # asserts = [
    #   {
    #     query = "SELECT count(collection) FROM documentdb_api.collection('documentdb','patient')";
    #     expected = "5";
    #     description = "documentdb can be queried successfully.";
    #   }
    # ];
  };

  meta = {
    description = "Graph database extension for PostgreSQL";
    longDescription = ''
      DocumentDB is the open-source engine powering vCore-based Azure Cosmos DB
      for MongoDB. It offers a native implementation of document-oriented NoSQL
      database, enabling seamless CRUD operations on BSON data types within a
      PostgreSQL framework.
    '';
    homepage = "https://documentdb.io/";
    downloadPage = "https://github.com/microsoft/documentdb/";
    changelog = "https://github.com/microsoft/documentdb/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ jk ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.mit;
  };
})
