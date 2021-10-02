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
  # kafka is optional but one of the most used features
, enableKafka ? true
  # TODO investigate adding "api" "api-client" "vrl-cli" and various "vendor-*"
  # "disk-buffer" is using leveldb TODO: investigate how useful
  # it would be, perhaps only for massive scale?
, features ? ([ "sinks" "sources" "transforms" ]
    # the second feature flag is passed to the rdkafka dependency
    # building on linux fails without this feature flag (both x86_64 and AArch64)
    ++ (lib.optionals enableKafka [ "rdkafka-plain" "rdkafka/dynamic_linking" ])
    ++ (lib.optional stdenv.targetPlatform.isUnix "unix"))
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "timberio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-10e0cWt6XW8msNR/RXbaOpdwTAlRLm6jVvDed905rho=";
  };

  cargoSha256 = "sha256-ezQ/tX/uKzJprLQt2xIUZwGuUOmuRmTO+gPsf3MLEv8=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ oniguruma openssl protobuf rdkafka zstd ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv coreutils CoreServices ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  RUSTONIG_SYSTEM_LIBONIG = true;
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoBuildFlags = [ "--no-default-features" "--features" (lib.concatStringsSep "," features) ];
  # TODO investigate compilation failure for tests
  # dev dependency includes httpmock which depends on iashc which depends on curl-sys with http2 feature enabled
  # compilation fails because of a missing http2 include
  doCheck = !stdenv.isDarwin;
  # healthcheck_grafana_cloud is trying to make a network access
  # test_stream_errors is flaky on linux-aarch64
  # tcp_with_tls_intermediate_ca is flaky on linux-x86_64
  checkPhase = ''
    TZDIR=${tzdata}/share/zoneinfo cargo test \
      --no-default-features \
      --features ${lib.concatStringsSep "," features} \
      -- --test-threads 1 \
      --skip=sinks::loki::tests::healthcheck_grafana_cloud \
      --skip=kubernetes::api_watcher::tests::test_stream_errors \
      --skip=sources::socket::test::tcp_with_tls_intermediate_ca
  '';

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
  };
}
