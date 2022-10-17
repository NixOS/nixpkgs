{ lib
, fetchFromGitHub
, buildGoModule
, enableUnfree ? true
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-2NezH7+hsOz+r+gong2CxXVjtxRyIKkA0G6OGoJcGFk=";
  };

  vendorSha256 = "sha256-6/wbxQ+Cv0lOlBqi8NUQQ8Z21w27betfeX/NiNDpOjA=";

  tags = lib.optionals (!enableUnfree) [ "oss" "nolimit" ];

  doCheck = false;

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester techknowlogick ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
