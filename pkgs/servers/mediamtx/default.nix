{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wqTES0E8HMBxMAmOiewSne1p9/ZI/Ikf1cr34lTqjwI=";
  };

  vendorHash = "sha256-C7j5jvRB4/GS0A05YZX8u62xvjevcKHpJFxuhzUX1+M=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}"
  ];

  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
