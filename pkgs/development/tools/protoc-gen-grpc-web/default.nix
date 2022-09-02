{ lib, stdenv, fetchFromGitHub, protobuf }:

stdenv.mkDerivation rec {
  pname = "protoc-gen-grpc-web";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-web";
    rev = version;
    sha256 = "sha256-NRShN4X9JmCjqPVY/q9oSxSOvv1bP//vM9iOZ6ap5vc=";
  };

  sourceRoot = "source/javascript/net/grpc/web/generator";

  strictDeps = true;
  nativeBuildInputs = [ protobuf ];
  buildInputs = [ protobuf ];

  makeFlags = [ "PREFIX=$(out)" "STATIC=no" ];

  patches = [
    # https://github.com/grpc/grpc-web/pull/1210
    ./optional-static.patch
  ];

  doCheck = true;
  checkInputs = [ protobuf ];
  checkPhase = ''
    runHook preCheck

    CHECK_TMPDIR="$TMPDIR/proto"
    mkdir -p "$CHECK_TMPDIR"

    protoc \
      --proto_path="${src}/packages/grpc-web/test/protos" \
      --plugin="./protoc-gen-grpc-web" \
      --grpc-web_out="import_style=commonjs,mode=grpcwebtext:$CHECK_TMPDIR" \
      echo.proto

    # check for grpc-web generated file
    [ -f "$CHECK_TMPDIR/echo_grpc_web_pb.js" ]

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/grpc/grpc-web";
    changelog = "https://github.com/grpc/grpc-web/blob/${version}/CHANGELOG.md";
    description = "gRPC web support for Google's protocol buffers";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
}
