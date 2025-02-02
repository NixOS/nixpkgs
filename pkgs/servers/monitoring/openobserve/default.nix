{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, bzip2
, oniguruma
, sqlite
, xz
, zlib
, zstd
, stdenv
, apple_sdk
, buildNpmPackage
}:

let
  version = "0.10.1";
  src = fetchFromGitHub {
    owner = "openobserve";
    repo = "openobserve";
    rev = "v${version}";
    hash = "sha256-68fJYk/R1F7FHm4F+pyyA9BRVdV8S8p5uEM1hVbuArg=";
  };
  web = buildNpmPackage {
    inherit src version;
    pname = "openobserve-ui";

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-7l1tdgR/R7qaYBbBm9OnKDBETPkaIN8AUgc9WdYQuwI=";

    preBuild = ''
      # Patch vite config to not open the browser to visualize plugin composition
      substituteInPlace vite.config.ts \
        --replace "open: true" "open: false";
    '';

    env = {
      NODE_OPTIONS = "--max-old-space-size=8192";
      # cypress tries to download binaries otherwise
      CYPRESS_INSTALL_BINARY = 0;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share
      mv dist $out/share/openobserve-ui
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "openobserve";
  inherit version src;

  patches = [
    # prevent using git to determine version info during build time
    ./build.rs.patch
  ];

  preBuild = ''
    cp -r ${web}/share/openobserve-ui web/dist
  '';
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chromiumoxide-0.5.7" = "sha256-GHrm5u8FtXRUjSRGMU4PNU6AJZ5W2KcgfZY1c/CBVYA=";
      "enrichment-0.1.0" = "sha256-FDPSCBkx+DPeWwTBz9+ORcbbiSBC2a8tJaay9Pxwz4w=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    bzip2
    oniguruma
    sqlite
    xz
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin (with apple_sdk.frameworks; [
    CoreFoundation
    CoreServices
    IOKit
    Security
    SystemConfiguration
  ]);

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;

    RUSTC_BOOTSTRAP = 1; # uses experimental features

    # the patched build.rs file sets these variables
    GIT_VERSION = src.rev;
    GIT_COMMIT_HASH = "builtByNix";
    GIT_BUILD_DATE = "1970-01-01T00:00:00Z";
  };

  # requires network access or filesystem mutations
  checkFlags = [
    "--skip handler::http::auth::tests::test_validate"
    "--skip handler::http::router::ui::tests::test_index_not_ok"
    "--skip handler::http::router::ui::tests::test_index_ok"
    "--skip handler::http::request::search::saved_view::tests::test_create_view_post"
    "--skip infra::cache::file_list::tests::test_get_file_from_cache"
    "--skip infra::cache::tmpfs::tests::test_delete_prefix"
    "--skip infra::cluster::tests::test_get_node_ip"
    "--skip infra::db::tests::test_delete"
    "--skip service::alerts::test::test_alerts"
    "--skip service::compact::merge::tests::test_compact"
    "--skip service::db::compact::file_list::tests::test_files"
    "--skip service::db::compact::file_list::tests::test_file_list_offset"
    "--skip service::db::compact::file_list::tests::test_file_list_process_offset"
    "--skip service::db::compact::files::tests::test_compact_files"
    "--skip service::db::user::tests::test_user"
    "--skip service::ingestion::grpc::tests::test_get_val"
    "--skip service::organization::tests::test_organization"
    "--skip service::search::sql::tests::test_sql_full"
    "--skip service::triggers::tests::test_triggers"
    "--skip service::users::tests::test_post_user"
    "--skip service::users::tests::test_user"
    "--skip common::infra::cache::file_data::disk::tests::test_get_file_from_cache"
    "--skip common::infra::cluster::tests::test_consistent_hashing"
    "--skip common::infra::db::tests::test_get"
    "--skip common::utils::auth::tests::test_is_root_user2"
    "--skip tests::e2e_test"
  ];

  meta = with lib; {
    description = "A cloud-native observability platform built specifically for logs, metrics, traces, analytics & realtime user-monitoring";
    homepage = "https://github.com/openobserve/openobserve";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "openobserve";
  };
}
