{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "grpc-tools";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    rev = "3a094f01711942f79abd8a536c45a91b574d626f"; # version 1.10.0 was not tagged
    sha256 = "1a7l91kxc3g7mqfqvhc3nb7zy0n21ifs5ck0qqg09qh3f44q04xm";
    fetchSubmodules = true;
  };

  sourceRoot = "source/packages/grpc-tools";

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 -t $out/bin grpc_node_plugin
    install -Dm755 -t $out/bin deps/protobuf/protoc
  '';

  meta = with lib; {
    description = "Distribution of protoc and the gRPC Node protoc plugin for ease of installation with npm";
    longDescription = ''
      This package distributes the Protocol Buffers compiler protoc along with
      the plugin for generating client and service objects for use with the Node
      gRPC libraries.
    '';
    homepage = "https://github.com/grpc/grpc-node/tree/master/packages/grpc-tools";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.nzhang-zh ];
  };
}
