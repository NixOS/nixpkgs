{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, pkg-config, protobuf
, Security, libiconv, rdkafka

, features ?
    (if stdenv.isAarch64
     then [ "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ]
     else [ "leveldb" "leveldb/leveldb-sys-2" "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ])
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner  = "timberio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1r6pqljrl0cqz5x09p6bmf4h52h8m02pg05a09idj86v0c0q6bw3";
  };

  cargoSha256 = "1c742g7a4z5lhr991hxdhwk8h0d43r4vv5bxj80sf3lynyx60yzf";
  buildInputs = [ openssl pkg-config protobuf rdkafka ]
                ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];

  # needed for internal protobuf c wrapper library
  PROTOC="${protobuf}/bin/protoc";
  PROTOC_INCLUDE="${protobuf}/include";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];
  # skip tests, too -- they don't respect the rdkafka flag...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A high-performance logs, metrics, and events router";
    homepage    = "https://github.com/timberio/vector";
    license     = with licenses; [ asl20 ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
}
