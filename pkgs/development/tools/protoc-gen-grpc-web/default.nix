{ lib
, stdenv
, fetchFromGitHub
, protobuf
, isStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-grpc-web";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-web";
    rev = finalAttrs.version;
    sha256 = "sha256-OetDAZ6zC8r7e82FILpQQnM+JHG9eludwhEuPaklrnw=";
  };

  sourceRoot = "${finalAttrs.src.name}/javascript/net/grpc/web/generator";

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs = [ protobuf ];
  buildInputs = [ protobuf ];

  makeFlags = [
    "PREFIX=$(out)"
    "STATIC=${if isStatic then "yes" else "no"}"
  ];

  doCheck = true;
  nativeCheckInputs = [ protobuf ];
  checkPhase = ''
    runHook preCheck

    CHECK_TMPDIR="$TMPDIR/proto"
    mkdir -p "$CHECK_TMPDIR"

    protoc \
      --proto_path="$src/packages/grpc-web/test/protos" \
      --plugin="./protoc-gen-grpc-web" \
      --grpc-web_out="import_style=commonjs,mode=grpcwebtext:$CHECK_TMPDIR" \
      echo.proto

    # check for grpc-web generated file
    [ -f "$CHECK_TMPDIR/echo_grpc_web_pb.js" ]

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/grpc/grpc-web";
    changelog = "https://github.com/grpc/grpc-web/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "gRPC web support for Google's protocol buffers";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
  };
})
