{ lib
, stdenv
, fetchFromGitHub
, protobuf
}:

stdenv.mkDerivation rec {
  pname = "protoc-gen-grpc-java";
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-java";
    rev = "v${version}";
    hash = "sha256-AenN9gQa/ppwRZfl8cXAmmVYy2IhIz6MemA1MJmrge0=";
  };

  sourceRoot = "source/compiler/src/java_plugin/cpp";

  postPatch = ''
    cp ${./Makefile} Makefile
  '';

  strictDeps = true;

  buildInputs = [ protobuf ];

  makeFlags = [
    "PREFIX=$(out)"
    "STATIC=no"
  ];

  meta = with lib; {
    homepage = "https://github.com/grpc/grpc-java";
    description = "The Java gRPC implementation. HTTP/2 based RPC";
    license = licenses.asl20;
    maintainers = with maintainers; [ ners ];
    platforms = platforms.unix;
  };
}
