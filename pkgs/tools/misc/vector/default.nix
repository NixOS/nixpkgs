{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, protobuf
, rdkafka
, oniguruma
, zstd
, rust-jemalloc-sys
, rust-jemalloc-sys-unprefixed
, Security
, libiconv
, coreutils
, CoreServices
, SystemConfiguration
, tzdata
, cmake
, perl
, git
  # nix has a problem with the `?` in the feature list
  # enabling kafka will produce a vector with no features at all
, enableKafka ? false
  # TODO investigate adding various "vendor-*"
  # "disk-buffer" is using leveldb TODO: investigate how useful
  # it would be, perhaps only for massive scale?
, features ? ([ "api" "api-client" "enrichment-tables" "sinks" "sources" "sources-dnstap" "transforms" "component-validation-runner" ]
    # the second feature flag is passed to the rdkafka dependency
    # building on linux fails without this feature flag (both x86_64 and AArch64)
    ++ lib.optionals enableKafka [ "rdkafka?/gssapi-vendored" ]
    ++ lib.optional stdenv.hostPlatform.isUnix "unix")
, nixosTests
, nix-update-script
}:

let
  pname = "vector";
  version = "0.40.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1vFDFdO9E5mUAUfEdg9Ec5ptq2Kp7HpqNz5+9CMn30U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "greptime-proto-0.1.0" = "sha256-Q8xr6qN6SAGGK0W96WuNRdQ5/8iNlruqzhXD6xq3Ua8=";
      "greptimedb-client-0.1.0" = "sha256-evL8Q2Ikct9s0r4DWTgSP/8g4XTishuJHmwRoCfQFbU=";
      "heim-0.1.0-rc.1" = "sha256-TFgLR5zb/oqceVOH4mIOvFFY/HMOLSo8VI5Eh9KP60E=";
      "nix-0.26.2" = "sha256-uquYvRT56lhupkrESpxwKEimRFhmYvri10n3dj0f2yg=";
      "ntapi-0.3.7" = "sha256-G6ZCsa3GWiI/FeGKiK9TWkmTxen7nwpXvm5FtjNtjWU=";
      "tokio-util-0.7.8" = "sha256-HCvtfohOoa1ZjD4s7QLDbIV4fe/MVBKtgM1QQX7gGKQ=";
      "tracing-0.2.0" = "sha256-YAxeEofFA43PX2hafh3RY+C81a2v6n1fGzYz2FycC3M=";
    };
  };

  nativeBuildInputs = [ pkg-config cmake perl git rustPlatform.bindgenHook ];
  buildInputs =
    [ oniguruma openssl protobuf rdkafka zstd ]
    ++ lib.optionals stdenv.isLinux [ rust-jemalloc-sys-unprefixed ]
    ++ lib.optionals stdenv.isDarwin [ rust-jemalloc-sys Security libiconv coreutils CoreServices SystemConfiguration ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  RUSTONIG_SYSTEM_LIBONIG = true;

  TZDIR = "${tzdata}/share/zoneinfo";

  # needed to dynamically link rdkafka
  CARGO_FEATURE_DYNAMIC_LINKING=1;

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  buildNoDefaultFeatures = true;
  buildFeatures = features;

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
      --replace "#[tokio::test]" ""
  '';

  passthru = {
    inherit features;
    tests = { inherit (nixosTests) vector; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "High-performance observability data pipeline";
    homepage = "https://github.com/vectordotdev/vector";
    license = licenses.mpl20;
    maintainers = with maintainers; [ thoughtpolice happysalada ];
    platforms = with platforms; all;
    mainProgram = "vector";
  };
}
