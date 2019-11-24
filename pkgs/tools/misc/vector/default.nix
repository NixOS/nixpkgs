{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, pkgconfig, protobuf
, Security, libiconv

, features ?
    (if stdenv.isAarch64
     then [ "jemallocator" ]
     else [ "leveldb" "jemallocator" ])

# Unfortunately, buildRustPackage does not really support using overrideAttrs
# on the underlying fields, because it doesn't pass them to stdenv.mkDerivation
# as an attr. making it a parameter is the only way to do so. sigh

, version ? "0.5.0"

, srcRef ? {
    rev    = "refs/tags/v${version}";
    sha256 = "0niyxlvphn3awrpfh1hbqy767cckgjzyjrkqjxj844czxhh1hhff";
  }

, cargoSha256 ? "0bdgan891hrah54g6aaysqizkxrfsbidnxihai0i7h7knzq9gsk5"
, patches ? []
}:

rustPlatform.buildRustPackage rec {
  pname = "vector";
  inherit version cargoSha256 patches;
  src = fetchFromGitHub {
    owner = "timberio";
    repo  = pname;
    inherit (srcRef) rev sha256;
  };

  buildInputs = [ openssl pkgconfig protobuf ]
                ++ stdenv.lib.optional stdenv.isDarwin [ Security libiconv ];

  # needed for internal protobuf c wrapper library
  PROTOC="${protobuf}/bin/protoc";
  PROTOC_INCLUDE="${protobuf}/include";

  # rdkafka fails to build, for some reason...
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
