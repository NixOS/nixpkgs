{ lib, buildGoModule, fetchFromGitHub }:
import ./versions.nix ({version, sha256}:
  buildGoModule {
  pname = "honeytail";
  inherit version;
<<<<<<< HEAD
  vendorHash = "sha256-LtiiLGLjhbfT49A6Fw5CbSbnmTHMxtcUssr+ayCVrvY=";
=======
  vendorSha256 = "sha256-LtiiLGLjhbfT49A6Fw5CbSbnmTHMxtcUssr+ayCVrvY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeytail";
    rev = "v${version}";
    hash = sha256;
  };
  inherit (buildGoModule.go) GOOS GOARCH;

  meta = with lib; {
    description = "agent for ingesting log file data into honeycomb.io and making it available for exploration";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
})

