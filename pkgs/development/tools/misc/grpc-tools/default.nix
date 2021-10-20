{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "grpc-tools";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    rev = "grpc-tools@${version}";
    sha256 = "00432y19pjcimwachjcqpzra21vzmlqchhhlqxnk98bfh25kxdcb";
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
