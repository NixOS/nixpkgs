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
, darwin
, buildNpmPackage
}:

let
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "openobserve";
    repo = "openobserve";
    rev = "v${version}";
    hash = "sha256-iHQDwHeKwoeA6pfmEp5KmaiMnGPf3yWSrXj1bu5ok8o=";
  };


  web = buildNpmPackage {
    inherit src version;
    pname = "openobserve-ui";

    sourceRoot = "source/web";

    npmDepsHash = "sha256-/wux95O6adXL4pYFobxkxu/cS2EAHjpWDfWIvLfSeiI=";

    env = {
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
  inherit src version;

  # prevent using git to determine version info during build time
  patches = [
    ./build.rs.patch
  ];

  preBuild = ''
    cp -r ${web}/share/openobserve-ui web/dist
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "enrichment-0.1.0" = "sha256-BOsuIkofMDfqxYox5wRSYJ+hpF4mv1frPSFItFChIFs=";
    };
  };

  buildInputs =
    [
      bzip2
      oniguruma
      sqlite
      xz
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

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
    "--skip infra::cache::file_list::tests::test_get_file_from_cache"
    "--skip infra::cache::tmpfs::tests::test_delete_prefix"
    "--skip infra::cluster::tests::test_get_node_ip"
    "--skip infra::db::tests::test_delete"
    "--skip service::db::compact::file_list::tests::test_files"
    "--skip common::infra::cache::file_data::disk::tests::test_get_file_from_cache"
  ];

  meta = with lib; {
    description = "A cloud native observability platform built specifically for logs, metrics, traces and analytics designed to work at petabyte scale";
    license = licenses.asl20;
    homepage = "https://openobserve.ai";
    changelog = "https://github.com/openobserve/openobserve/releases";
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "openobserve"; #TODO
  };
}
