{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, llvmPackages
, openssl
, protobuf
, rdkafka
, oniguruma
, zstd
, Security
, libiconv
, coreutils
, CoreServices
, tzdata
, cmake
, perl
  # nix has a problem with the `?` in the feature list
  # enabling kafka will produce a vector with no features at all
, enableKafka ? false
  # TODO investigate adding "api" "api-client" "vrl-cli" and various "vendor-*"
  # "disk-buffer" is using leveldb TODO: investigate how useful
  # it would be, perhaps only for massive scale?
, features ? ([ "sinks" "sources" "transforms" "vrl-cli" ]
    # the second feature flag is passed to the rdkafka dependency
    # building on linux fails without this feature flag (both x86_64 and AArch64)
    ++ lib.optionals enableKafka [ "rdkafka?/gssapi-vendored" ]
    ++ lib.optional stdenv.targetPlatform.isUnix "unix")
}:

let
  pname = "vector";
  version = "0.24.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kZ6Ek3CagAznyU7yDv96jFk1xCjfF2gvrNYyVTeFuO0=";
  };

  cargoSha256 = "sha256-4aHMPrawTF9QpoX7cmiPv9ddu0LF008uqBTu0oyan98=";
  nativeBuildInputs = [ pkg-config cmake perl ];
  buildInputs = [ oniguruma openssl protobuf rdkafka zstd ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv coreutils CoreServices ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  RUSTONIG_SYSTEM_LIBONIG = true;
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  TZDIR = "${tzdata}/share/zoneinfo";

  # needed to dynamically link rdkafka
  CARGO_FEATURE_DYNAMIC_LINKING=1;

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

    ${lib.optionalString (!builtins.elem "transforms-geoip" features) ''
        substituteInPlace ./Cargo.toml --replace '"transforms-geoip",' ""
    ''}
  '';

  passthru = { inherit features; };

  meta = with lib; {
    description = "A high-performance logs, metrics, and events router";
    homepage = "https://github.com/timberio/vector";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ thoughtpolice happysalada ];
    platforms = with platforms; linux;
  };
}
