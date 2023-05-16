{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "protoc-gen-go-vtproto";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "vtprotobuf";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-2DpL8CYl0MWpr7TBJPwDlgKvOoa5RrVwMjOxrEP5Wio=";
=======
    sha256 = "sha256-WtiXoQWjjFf+TP2zpAXNH05XdcrLSpw3S0TG4lkzp2E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-JpSVO8h7+StLG9/dJQkmrIlh9zIHABoqP1hq+X5ajVs=";

  excludedPackages = [ "conformance" ];

  meta = with lib; {
    description = "A Protocol Buffers compiler that generates optimized marshaling & unmarshaling Go code for ProtoBuf APIv2";
    homepage = "https://github.com/planetscale/vtprotobuf";
    license = licenses.bsd3;
    maintainers = [ maintainers.zane ];
  };
}
