{ lib
, stdenv
, cmake
, fetchFromGitHub
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "grpc-tools";
<<<<<<< HEAD
  version = "1.12.4";
=======
  version = "1.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-node";
    rev = "grpc-tools@${version}";
<<<<<<< HEAD
    hash = "sha256-708lBIGW5+vvSTrZHl/kc+ck7JKNXElrghIGDrMSyx8=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/grpc-tools";
=======
    sha256 = "00432y19pjcimwachjcqpzra21vzmlqchhhlqxnk98bfh25kxdcb";
    fetchSubmodules = true;
  };

  sourceRoot = "source/packages/grpc-tools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dm755 -t $out/bin grpc_node_plugin
    install -Dm755 -t $out/bin deps/protobuf/protoc
  '';

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://github.com/grpc/grpc-node.git";
    rev-prefix = "grpc-tools@";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
