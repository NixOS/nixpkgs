{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
, protobuf
, Security
}:

let
  pname = "quickwit";
  version = "0.6.4";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "quickwit-oss";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-stlm3oDMQVoMza3s4JApynXbzhrarfXw3uAxGMZQJqs=";
  };

  postPatch = ''
    substituteInPlace ./quickwit-ingest/build.rs \
      --replace '&[]' '&["."]'
    substituteInPlace ./quickwit-codegen/example/build.rs \
      --replace '&[]' '&["."]'
    substituteInPlace ./quickwit-proto/build.rs \
      --replace '&[]' '&["."]'
  '';

  sourceRoot = "${src.name}/quickwit";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "chitchat-0.5.0" = "sha256-gGWMzTzQNb9JXSbPIanMJpEKhKen1KsIrWQz6wvypDY=";
      "ownedbytes-0.5.0" = "sha256-ZuWwj5EzDm4YOUU/MhmR7CBOHM444ljBFSkC+wLBia4=";
      "path-0.1.0" = "sha256-f+Iix+YuKy45zoQXH7ctzANaL96s7HNUBOhcM1ZV0Ko=";
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
