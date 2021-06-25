{ lib, fetchFromGitHub, buildGoModule
, enableUnfree ? true }:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.0.0";

  vendorSha256 = "sha256-cnbZSnHU+ORm7/dV+U9NfM18Zrzi24vf7qITPJsusU8=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-BxwCJf3uY34rqegZJ6H/zb63orELhq41trOgzGXQe80=";
  };

  preBuild = ''
    buildFlagsArray+=( "-tags" "${lib.optionalString (!enableUnfree) "oss nolimit"}" )
  '';

  meta = with lib; {
    maintainers = with maintainers; [ elohmeier vdemeester ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
    description = "Continuous Integration platform built on container technology";
  };
}
