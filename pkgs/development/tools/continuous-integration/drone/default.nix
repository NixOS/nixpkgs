{ lib
, fetchFromGitHub
, buildGoModule
, enableUnfree ? true
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
<<<<<<< HEAD
  version = "2.20.0";
=======
  version = "2.17.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-YiKULnLSP5wgrYob1t4HssGS9ubSR5dHECIwnAicg8M=";
  };

  vendorHash = "sha256-3GPe76zcyKItYWedmnAnmN4c1AorQePxxWXkRk0vNpk=";
=======
    sha256 = "sha256-b+kttHGH6KVsq9MR0bni7Gh1ZCIPkFzCvhoBdiC5Mk8=";
  };

  vendorHash = "sha256-I4GQ/KRM8vFOaMrGdSWll5PAk8ivFXdje7GTGYRPECw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  doCheck = false;

  meta = with lib; {
    description = "Continuous Integration platform built on container technology";
    homepage = "https://github.com/harness/drone";
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
