{ lib, fetchFromGitHub, buildGoModule
, enableUnfree ? true }:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.12.1";

  vendorSha256 = "sha256-hKJFYjIJVuGBiSIeTitI7kZdGjSRUTCPMhH72O0wm3I=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-ZngZzpFjQLkiBDNrmgPXPCfDoeZbX/ynBXkuNrrGz3E=";
  };

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
