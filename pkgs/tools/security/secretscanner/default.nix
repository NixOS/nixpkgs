{ lib
, buildGoModule
, fetchFromGitHub
, hyperscan
, pkg-config
<<<<<<< HEAD
, protobuf
, protoc-gen-go
, protoc-gen-go-grpc
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "secretscanner";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "20210214-${lib.strings.substring 0 7 rev}";
  rev = "42a38f9351352bf6240016b5b93d971be35cad46";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deepfence";
    repo = "SecretScanner";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-lTUZLuEiC9xpHYWn3uv4ZtbvHX6ETsjxacjd/O0kU8I=";
  };

  vendorHash = "sha256-lB+fiSdflIYGw0hMN0a9IOtRcJwYEUPQqaeU7mAfSQs=";

  excludedPackages = [
    "./agent-plugins-grpc/proto" # No need to build submodules
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  buildInputs = [
    hyperscan
  ];

  preBuild = ''
    # Compile proto files
    make -C agent-plugins-grpc go
  '';
=======
    inherit rev;
    sha256 = "0yga71f7bx5a3hj5agr88pd7j8jnxbwqm241fhrvv8ic4sx0mawg";
  };

  vendorSha256 = "0b7qa83iqnigihgwlqsxi28n7d9h0dk3wx1bqvhn4k01483cipsd";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ hyperscan ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mv $out/bin/SecretScanner $out/bin/$pname
  '';

  meta = with lib; {
    description = "Tool to find secrets and passwords in container images and file systems";
    homepage = "https://github.com/deepfence/SecretScanner";
<<<<<<< HEAD
    changelog = "https://github.com/deepfence/SecretScanner/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

