{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, pkg-config, protobuf
, Security, libiconv, rdkafka
, tzdata

, features ?
    (if stdenv.isAarch64
     then [ "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ]
     else [ "leveldb" "leveldb/leveldb-sys-2" "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ])
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner  = "timberio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0k15scvjcg2v4z80vq27yrn2wm50fp8xj8lga2czzs0zxhlv21nl";
  };

  cargoSha256 = "1al8jzjxjhxwb5n1d52pvl59d11g0bdg2dcw8ir2nclya1w68f2w";
  buildInputs = [ openssl pkg-config protobuf rdkafka ]
                ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];

  # needed for internal protobuf c wrapper library
  PROTOC="${protobuf}/bin/protoc";
  PROTOC_INCLUDE="${protobuf}/include";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];
  checkPhase = "TZDIR=${tzdata}/share/zoneinfo cargo test --no-default-features --features ${lib.concatStringsSep "," features},disable-resolv-conf -- --test-threads 1";

  meta = with stdenv.lib; {
    description = "A high-performance logs, metrics, and events router";
    homepage    = "https://github.com/timberio/vector";
    license     = with licenses; [ asl20 ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
}
