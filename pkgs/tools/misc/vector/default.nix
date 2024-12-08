{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
  rdkafka,
  oniguruma,
  zstd,
  rust-jemalloc-sys,
  rust-jemalloc-sys-unprefixed,
  Security,
  libiconv,
  coreutils,
  CoreServices,
  SystemConfiguration,
  tzdata,
  cmake,
  perl,
  git,
  nixosTests,
  nix-update-script,
  darwin,
}:

let
  pname = "vector";
  version = "0.43.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PyQ7UDgQ1UWAfOHt9bne9X6+sSx5EFruqzVJThYXoZY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "greptime-proto-0.1.0" = "sha256-QT3PZnHJoVghuRCGoZIH6L8jnX7Wn9eSuQqHIyrUY4E=";
      "greptimedb-ingester-0.1.0" = "sha256-1M9yWXDZ6U9JTVyXQg9ZcSSGJp7GXtaCfQHdtjhw6FY=";
      "heim-0.1.0-rc.1" = "sha256-pMraYKr6srTQqEzoBx9gGHHlJ7nMKwj50ftimQAkfL0=";
      "nix-0.26.2" = "sha256-uquYvRT56lhupkrESpxwKEimRFhmYvri10n3dj0f2yg=";
      "ntapi-0.3.7" = "sha256-G6ZCsa3GWiI/FeGKiK9TWkmTxen7nwpXvm5FtjNtjWU=";
      "tokio-util-0.7.11" = "sha256-oV9fSPjLMY1KbcbDP2WTVjF/N0qlQBPDIYHOp3aNCTY=";
      "tracing-0.2.0" = "sha256-YAxeEofFA43PX2hafh3RY+C81a2v6n1fGzYz2FycC3M=";
    };
  };

  nativeBuildInputs =
    [
      pkg-config
      cmake
      perl
      git
      rustPlatform.bindgenHook
    ]
    # Provides the mig command used by the build scripts
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.bootstrap_cmds;
  buildInputs =
    [
      oniguruma
      openssl
      protobuf
      rdkafka
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ rust-jemalloc-sys-unprefixed ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rust-jemalloc-sys
      Security
      libiconv
      coreutils
      CoreServices
      SystemConfiguration
    ];

  # Rust 1.80.0 introduced the unexepcted_cfgs lint, which requires crates to allowlist custom cfg options that they inspect.
  # Upstream is working on fixing this in https://github.com/vectordotdev/vector/pull/20949, but silencing the lint lets us build again until then.
  # TODO remove when upgrading Vector
  RUSTFLAGS = "--allow dependency_on_unit_never_type_fallback --allow dead_code";

  # Without this, we get SIGSEGV failure
  RUST_MIN_STACK = 33554432;

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  RUSTONIG_SYSTEM_LIBONIG = true;

  TZDIR = "${tzdata}/share/zoneinfo";

  # needed to dynamically link rdkafka
  CARGO_FEATURE_DYNAMIC_LINKING = 1;

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  # TODO investigate compilation failure for tests
  # there are about 100 tests failing (out of 1100) for version 0.22.0
  doCheck = false;

  checkFlags = [
    # tries to make a network access
    "--skip=sinks::loki::tests::healthcheck_grafana_cloud"

    # flaky on linux-aarch64
    "--skip=kubernetes::api_watcher::tests::test_stream_errors"

    # flaky on linux-x86_64
    "--skip=sources::socket::test::tcp_with_tls_intermediate_ca"
    "--skip=sources::host_metrics::cgroups::tests::generates_cgroups_metrics"
    "--skip=sources::aws_kinesis_firehose::tests::aws_kinesis_firehose_forwards_events"
    "--skip=sources::aws_kinesis_firehose::tests::aws_kinesis_firehose_forwards_events_gzip_request"
    "--skip=sources::aws_kinesis_firehose::tests::handles_acknowledgement_failure"
  ];

  # recent overhauls of DNS support in 0.9 mean that we try to resolve
  # vector.dev during the checkPhase, which obviously isn't going to work.
  # these tests in the DNS module are trivial though, so stubbing them out is
  # fine IMO.
  #
  # the geoip transform yields maxmindb.so which contains references to rustc.
  # neither figured out why the shared object is included in the output
  # (it doesn't seem to be a runtime dependencies of the geoip transform),
  # nor do I know why it depends on rustc.
  # However, in order for the closure size to stay at a reasonable level,
  # transforms-geoip is patched out of Cargo.toml for now - unless explicitly asked for.
  postPatch = ''
    substituteInPlace ./src/dns.rs \
      --replace-fail "#[tokio::test]" ""
  '';

  passthru = {
    tests = {
      inherit (nixosTests) vector;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "High-performance observability data pipeline";
    homepage = "https://github.com/vectordotdev/vector";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      thoughtpolice
      happysalada
    ];
    platforms = with platforms; all;
    mainProgram = "vector";
  };
}
