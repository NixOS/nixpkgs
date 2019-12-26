{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, pkgconfig, protobuf
, Security, libiconv, rdkafka

, features ?
    (if stdenv.isAarch64
     then [ "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ]
     else [ "leveldb" "leveldb/leveldb-sys-2" "shiplift/unix-socket" "jemallocator" "rdkafka" "rdkafka/dynamic_linking" ])
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "timberio";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0bb4552nwkdpnxhaq2mn4iz5w92ggqxc1b78jq2vjbh1317sj9hw";
  };

  cargoSha256 = "1akyzrscc6pv7ggb1kna05vvxhfzrf1b4kji4bah1ry3yyqxdjsj";
  buildInputs = [ openssl pkgconfig protobuf rdkafka ]
                ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];

  # needed for internal protobuf c wrapper library
  PROTOC="${protobuf}/bin/protoc";
  PROTOC_INCLUDE="${protobuf}/include";

  cargoBuildFlags = [ "--no-default-features" "--features" "${lib.concatStringsSep "," features}" ];
  checkPhase = ":"; # skip tests, too -- they don't respect the rdkafka flag...

  meta = with stdenv.lib; {
    description = "A high-performance logs, metrics, and events router";
    homepage    = "https://github.com/timberio/vector";
    license     = with licenses; [ asl20 ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
}
