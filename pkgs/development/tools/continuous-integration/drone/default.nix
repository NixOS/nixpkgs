{ lib, fetchFromGitHub, buildGoModule
, enableUnfree ? true }:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.11.1";

  vendorSha256 = "sha256-oJBGHr4LjrX7e197s4tqkiysWJS3RRW6JWI9ncs/uHw=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-bbWJo7PnwQaVKRpSnRK5pm0cD9orlkEOUa+y7UnACjg=";
  };

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
