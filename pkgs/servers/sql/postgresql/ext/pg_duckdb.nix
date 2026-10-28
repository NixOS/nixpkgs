{
  lib,
  fetchFromGitHub,
  writeText,

  postgresqlBuildExtension,
  postgresqlTestExtension,
  postgresql,

  openssl,
  curl,

  cmake,
  ninja,
  pkg-config,
  python3,
  git,
  which,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "pg_duckdb";
  version = "1.1.1";

  # duckdbVersionFull is used to set OVERRIDE_GIT_DESCRIBE, which effectively suppresses
  # build script attempts to use git to figure it out.
  # To get the version first run `git submodule update --init --recursive` inside pg_duckdb/,
  # then run `git describe --tags --long --match "v*.*.*"` inside pg_duckdb/third_party/duckdb
  duckdbVersion = "1.4.3";
  duckdbVersionFull = "${finalAttrs.duckdbVersion}-0-gd1dc88f950";

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "pg_duckdb";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-B/9U1j29zqNMNgK2t2MFJemCrLgQo1qRrCacSjPzYdg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    git
    which
  ];

  # Avoid build errors by suppressing these hooks.
  # Extension build scripts drive cmake and ninja themselves.
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  # curl is required by httpfs (duckdb-httpfs/vcpkg.json), but not included in postgresql.buildInputs
  buildInputs = postgresql.buildInputs ++ [
    openssl
    curl
  ];

  # 1. Disable calling `git submodule update --init --recursive` from Makefile:
  # submodules are already in place thanks to fetchFromGitHub's fetchSubmodules option.
  # 2. duckdb-httpfs prefers to use vcpkg to build its dependencies (see
  # duckdb-httpfs/README.md), but this derivation won't run vcpkg, so the
  # libraries are linked dynamically. But because the -lssl and -lcrypto flags
  # are missing, libssl/libcrypto symbols can't be resolved during the link time.
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail \
        'git submodule update --init --recursive' \
        'true'

    substituteInPlace Makefile \
      --replace-fail \
        'PG_DUCKDB_LINK_FLAGS += -Wl,-rpath,$(PG_LIB)/ -L$(DUCKDB_BUILD_DIR)/src -L$(PG_LIB) -lstdc++ -llz4' \
        'PG_DUCKDB_LINK_FLAGS += -Wl,-rpath,$(PG_LIB)/ -L$(DUCKDB_BUILD_DIR)/src -L$(PG_LIB) -lstdc++ -llz4 -lssl -lcrypto'
  '';

  # Download httpfs extension source code and override pg_duckdb's attempt to
  # get it using git in pg_duckdb_extensions.cmake by using EXTENSION_CONFIGS
  httpfsSrc = fetchFromGitHub {
    owner = "duckdb";
    repo = "duckdb-httpfs";
    rev = "9c7d34977b10346d0b4cbbde5df807d1dab0b2bf";
    fetchSubmodules = true;
    hash = "sha256-/gR99nrks2nRmfk1ypZCSAKpok1DGizXgNz0u5Bw3Jk=";
  };

  makeFlags =
    let
      httpfsCmake = writeText "pg_duckdb_httpfs.cmake" ''
        duckdb_extension_load(httpfs
          SOURCE_DIR ${finalAttrs.httpfsSrc}
          EXTENSION_VERSION v${finalAttrs.duckdbVersion}
        )
      '';
    in
    [
      "GEN=ninja"
      "DUCKDB_BUILD=ReleaseStatic"
      "PG_CONFIG=${postgresql.pg_config}/bin/pg_config"
      "DUCKDB_VERSION=v${finalAttrs.duckdbVersionFull}"
      "EXTENSION_CONFIGS=${httpfsCmake};../pg_duckdb_extensions.cmake"
    ];

  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    postgresqlExtraSettings = ''
      shared_preload_libraries = 'pg_duckdb'
    '';
    sql = ''
      CREATE EXTENSION pg_duckdb;
      SELECT duckdb.raw_query('SELECT 42');
    '';
  };

  meta = {
    description = "DuckDB-powered Postgres extension for high-performance analytics";
    homepage = "https://github.com/duckdb/pg_duckdb";
    changelog = "https://github.com/duckdb/pg_duckdb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skonotopov ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
