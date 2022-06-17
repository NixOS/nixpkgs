{ lib, fetchFromGitHub, buildGoModule
, enableUnfree ? true }:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.12.0";

  vendorSha256 = "sha256-y9knuU/+hkXBLgMmJ5Trp0A3lEiLC1I2Dh85/CFBXow=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-Bpv08iD0wRiscwNE8TIBgZMlChQFQEegbjkzDv4mIYU=";
  };

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
