{ lib
, fetchFromGitHub
, buildGoModule
, enableUnfree ? true
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-b+kttHGH6KVsq9MR0bni7Gh1ZCIPkFzCvhoBdiC5Mk8=";
  };

  vendorHash = "sha256-I4GQ/KRM8vFOaMrGdSWll5PAk8ivFXdje7GTGYRPECw=";

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  doCheck = false;

  meta = with lib; {
    description = "Continuous Integration platform built on container technology";
    homepage = "https://github.com/harness/drone";
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
