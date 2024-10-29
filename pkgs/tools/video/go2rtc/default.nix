{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    rev = "refs/tags/v${version}";
    hash = "sha256-avak2cc8KDmlTrQutzULuvkWxSgdv3rMI7+G3+jNcdI=";
  };

  vendorHash = "sha256-N8aJmxNQ/p2ddJG9DuIVVjcgzEC6TzD0sz992h3q0RU=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # tests fail

  meta = with lib; {
    description = "Ultimate camera streaming application with support RTSP, RTMP, HTTP-FLV, WebRTC, MSE, HLS, MJPEG, HomeKit, FFmpeg, etc";
    homepage = "https://github.com/AlexxIT/go2rtc";
    changelog = "https://github.com/AlexxIT/go2rtc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "go2rtc";
  };
}
