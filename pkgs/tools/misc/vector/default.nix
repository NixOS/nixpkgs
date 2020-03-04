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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "timberio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0girph2icl95klwqh3ksyr7fwril2pyb2gmnphgxrs6bibp1a2ha";
  };

  cargoSha256 = "1f4c982i2r2y63h0a79nlwdwrp81ps93zan7a6ag5w7c4223ab5g";
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
