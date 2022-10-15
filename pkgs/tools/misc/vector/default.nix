{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  # TODO investigate adding "vrl-cli" and various "vendor-*"
  # "disk-buffer" is using leveldb TODO: investigate how useful
  # it would be, perhaps only for massive scale?
, features ? ([ "api" "api-client" "sinks" "sources" "transforms" "vrl-cli" ]
    # the second feature flag is passed to the rdkafka dependency
    # building on linux fails without this feature flag (both x86_64 and AArch64)
    ++ lib.optionals enableKafka [ "rdkafka?/gssapi-vendored" ]
    ++ lib.optional stdenv.targetPlatform.isUnix "unix")
}:

let
  pname = "vector";
  version = "0.24.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RfKg14r3B5Jx2vIa4gpJs5vXRqSXKOXKRFmmQmzQorQ=";
  };

  patches = [
    (fetchpatch {
      name = "rust-1.64-part1.patch";
      url = "https://github.com/vectordotdev/vector/commit/e7437df97711b6a660a3532fe5026244472a900f.patch";
      hash = "sha256-EyheI3nngt72+ZZNNsjp3KV1CuRb9CZ7wUCHt0twFVs=";
    })
    (fetchpatch {
      name = "rust-1.64-part2.patch";
      url = "https://github.com/vectordotdev/vector/commit/e80c7afaf7601cf936c7c3468bd7b4b230ef6149.patch";
      hash = "sha256-pHcq7XLn+9PKs0DnBTK5FawN5KSF8BuJf7sBO9u5Gb8=";
      excludes = [
        # There are too many conflicts to easily resolve patching this file, but
        # the changes here do not block compilation.
        "lib/lookup/src/lookup_v2/owned.rs"
      ];
    })
  ];

  cargoHash = "sha256-l2rrT2SeeH4bYYlzSiFASNBxtg4TBm1dRA4cFRfvpkk=";
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
    platforms = with platforms; all;
  };
}

