{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, protobuf
, Security
, libiconv
, rdkafka
, tzdata
, coreutils
, CoreServices
, features ? ([ "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ]
    ++ (lib.optional stdenv.targetPlatform.isUnix "unix")
    ++ [ "sinks" "sources" "transforms" ])
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "timberio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ige0138alZ0KAmPakPVmDVydz5qco6m0xK7AEzScyXc=";
  };

  cargoSha256 = "sha256-oK4M6zTfI0QVW9kQTgpP/vSxFt2VlRABmKvQ4aAqC74=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl protobuf rdkafka ]
    ++ lib.optional stdenv.isDarwin [ Security libiconv coreutils CoreServices ];

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  cargoBuildFlags = [ "--no-default-features" "--features" (lib.concatStringsSep "," features) ];
  checkPhase = "TZDIR=${tzdata}/share/zoneinfo cargo test --no-default-features --features ${lib.concatStringsSep "," features} -- --test-threads 1";

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
