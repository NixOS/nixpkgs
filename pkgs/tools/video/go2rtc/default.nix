{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    rev = "refs/tags/v${version}";
    hash = "sha256-6zENPF4VBNErdjg0W+UwWZKKexYC1soZ45nJa+hSD7M=";
  };

  vendorHash = "sha256-VI6OODJLKrCvehM4W96Qh3PvZoIM2GlE5cgyvSaCv+8=";

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
  };
}
