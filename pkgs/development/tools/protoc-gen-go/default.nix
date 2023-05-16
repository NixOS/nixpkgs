{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoc-gen-go";
<<<<<<< HEAD
  version = "1.31.0";
=======
  version = "1.29.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wKJYy/9Bld6GXM1VFYXEs9//Y27eLrqDdw+a9P9EwfU=";
  };

  vendorHash = "sha256-yb8l4ooZwqfvenlxDRg95rqiL+hmsn0weS/dPv/oD2Y=";
=======
    sha256 = "sha256-xlRHhr25+gXlO6ggIQgijWYzIVZCpRVCnuLnSW1r15s=";
  };

  vendorSha256 = "sha256-yb8l4ooZwqfvenlxDRg95rqiL+hmsn0weS/dPv/oD2Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/protoc-gen-go" ];

  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
