{ lib, stdenv, fetchFromGitHub, protobuf }:

stdenv.mkDerivation rec {
  pname = "protoc-gen-grpc-web";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-web";
    rev = version;
    sha256 = "sha256-piKpaylzuanhGR+7BzApplv8e/CWPoR9tG3vHrF7WXw=";
  };

  sourceRoot = "source/javascript/net/grpc/web/generator";

  strictDeps = true;
  nativeBuildInputs = [ protobuf ];
  buildInputs = [ protobuf ];

  makeFlags = [ "PREFIX=$(out)" ];

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
