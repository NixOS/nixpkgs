{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  protobuf,
  rust-jemalloc-sys,
  Security,
}:

let
  pname = "quickwit";
  version = "0.8.0";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FZVGQfDuQYIdRnCsBZvXeLbJBdcLugZeHNm+kf6L9SY=";
  };

  postPatch = ''
    substituteInPlace ./quickwit-ingest/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-codegen/example/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
    substituteInPlace ./quickwit-proto/build.rs \
      --replace-fail '.with_protos' '.with_includes(&["."]).with_protos'
  '';

  sourceRoot = "${src.name}/quickwit";

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chitchat-0.8.0" = "sha256-cjwKaBXoztYUXgnJvtFH+OSQU6tl2U3zKFWX324+9wo=";
      "mrecordlog-0.4.0" = "sha256-9LIVs+BqK9FLSfHL3vm9LL+/FXIXJ6v617QLv4luQik=";
      "ownedbytes-0.6.0" = "sha256-in18/NYYIgUiZ9sm8NgJlebWidRp34DR7AhOD1Nh0aw=";
      "pulsar-5.0.2" = "sha256-j7wpsAro6x4fk3pvSL4fxLkddJFq8duZ7jDj0Edf3YQ=";
      "sasl2-sys-0.1.20+2.1.28" = "sha256-u4BsfmTDFxuY3i1amLCsr7MDv356YPThMHclura0Sxs=";
      "whichlang-0.1.0" = "sha256-7AvLGjtWHjG0TnZdg9p5D+O0H19uo2sqPxJMn6mOU0k=";
    };
  };

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  passthru.updateScript = nix-update-script { };

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
