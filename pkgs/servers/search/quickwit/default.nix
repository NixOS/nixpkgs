{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
  protobuf,
  rust-jemalloc-sys,
  Security,
  nodejs,
  yarn,
  fetchYarnDeps,
  fixup-yarn-lock,
}:

let
  pname = "quickwit";
  version = "0.8.2";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/quickwit/quickwit-ui/yarn.lock";
    hash = "sha256-HppK9ycUxCOIagvzCmE+VfcmfMQfPIC8WeWM6WbA6fQ=";
  };

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OrCO0mCFmhYBdpr4Gps56KJJ37uuJpV6ZJHWspOScyw=";
  };

  quickwit-ui = stdenv.mkDerivation {
    name = "quickwit-ui";
    src = "${src}/quickwit/quickwit-ui";

    nativeBuildInputs = [
      nodejs
      yarn
      fixup-yarn-lock
    ];

    configurePhase = ''
      export HOME=$(mktemp -d)
    '';

    buildPhase = ''
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup-yarn-lock yarn.lock

      yarn install --offline \
        --frozen-lockfile --no-progress \
        --ignore-engines --ignore-scripts
      patchShebangs .

      yarn build
    '';

    installPhase = ''
      mkdir $out
      mv build/* $out
    '';
  };
in
rustPlatform.buildRustPackage rec {
  inherit pname version src;

  postPatch = ''
    substituteInPlace ./quickwit-ingest/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-codegen/example/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-proto/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    cp /build/cargo-vendor-dir/Cargo.lock /build/source/quickwit/Cargo.lock
  '';

  sourceRoot = "${src.name}/quickwit";

  preBuild = ''
    mkdir -p quickwit-ui/build
    cp -r ${quickwit-ui}/* quickwit-ui/build
  '';

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-Q2FIobrYD3ir12TZtNUi8dmWs4QmjwbcuorVBnMg88s=";

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  passthru = {
    tests = {
      inherit (nixosTests) quickwit;
      inherit (nixosTests.vector) syslog-quickwit;
    };
    updateScript = nix-update-script { };
  };

  checkFlags = [
    # tries to make a network access
    "--skip=test_all_local_index"
    "--skip=test_cmd_create"
    "--skip=test_cmd_create_no_index_uri"
    "--skip=test_cmd_search_aggregation"
    "--skip=test_cmd_search_with_snippets"
    "--skip=test_delete_index_cli"
    "--skip=test_delete_index_cli_dry_run"
    "--skip=test_ingest_docs_cli"
    "--skip=test_ingest_docs_cli_keep_cache"
    "--skip=test_search_index_cli"
    "--skip=test_garbage_collect_cli_no_grace"
    "--skip=actors::indexing_service::tests::test_indexing_service_spawn_observe_detach"
    "--skip=object_storage::s3_compatible_storage::tests::test_s3_compatible_storage_relative_path"
    # flaky test
    "--skip=actors::indexer::tests::test_indexer_triggers_commit_on_drained_mailbox"
    "--skip=actors::indexer::tests::test_indexer_triggers_commit_on_timeout"
    "--skip=actors::indexer::tests::test_indexer_partitioning"
    "--skip=actors::indexing_pipeline::tests::test_merge_pipeline_does_not_stop_on_indexing_pipeline_failure"
    "--skip=actors::indexer::tests::test_indexer_triggers_commit_on_target_num_docs"
    "--skip=actors::packager::tests::test_packager_simple"
    # fail on darwin for some reason
    "--skip=io::tests::test_controlled_writer_limited_async"
    "--skip=io::tests::test_controlled_writer_limited_sync"
  ];

  meta = with lib; {
    description = "Sub-second search & analytics engine on cloud storage";
    homepage = "https://quickwit.io/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
