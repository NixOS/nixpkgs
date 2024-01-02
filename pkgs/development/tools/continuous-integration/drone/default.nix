{ lib
, fetchFromGitHub
, buildGoModule
, enableUnfree ? true
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-YiKULnLSP5wgrYob1t4HssGS9ubSR5dHECIwnAicg8M=";
  };

  vendorHash = "sha256-3GPe76zcyKItYWedmnAnmN4c1AorQePxxWXkRk0vNpk=";

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  doCheck = false;

  meta = with lib; {
    description = "Continuous Integration platform built on container technology";
    homepage = "https://github.com/harness/drone";
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
