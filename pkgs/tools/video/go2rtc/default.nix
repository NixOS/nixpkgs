{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    rev = "refs/tags/v${version}";
    hash = "sha256-XG98CJZ9bnFfJL5DyhDon+j74cXXmxYb291PElqXXRY=";
  };

  vendorHash = "sha256-KEW3ykEZvL6y1VacDIqtHW9B2RLHlHC29aqJjkEnRqQ=";

  buildFlagArrays = [
    "-trimpath"
  ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # tests fail

  meta = with lib; {
    description = "Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MJPEG, HomeKit, FFmpeg, etc.";
    homepage = "https://github.com/AlexxIT/go2rtc";
    changelog = "https://github.com/AlexxIT/go2rtc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "go2rtc";
  };
}
