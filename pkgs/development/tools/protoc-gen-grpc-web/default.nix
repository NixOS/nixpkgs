{ lib, stdenv, fetchFromGitHub, fetchpatch, protobuf }:

stdenv.mkDerivation rec {
  pname = "protoc-gen-grpc-web";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-web";
    rev = version;
    sha256 = "sha256-NBENyc01O8NPo84z1CeZ7YvFvVGY2GSlcdxacRrQALw=";
  };

  sourceRoot = "source/javascript/net/grpc/web";

  # remove once PR merged
  # https://github.com/grpc/grpc-web/pull/1107
  patches = [
    (fetchpatch {
      name = "add-prefix.patch";
      url = "https://github.com/06kellyjac/grpc-web/commit/b0803be1080fc635a8d5b88da971835a888a0c77.patch";
      stripLen = 4;
      sha256 = "sha256-Rw9Z7F8cYrc/UIGUN6yXOus4v+Qn9Yf1Nc301TFx85A=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ protobuf ];
  buildInputs = [ protobuf ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/grpc/grpc-web";
    changelog = "https://github.com/grpc/grpc-web/blob/${version}/CHANGELOG.md";
    description = "gRPC web support for Google's protocol buffers";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
