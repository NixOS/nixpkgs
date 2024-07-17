{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go2rtc";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "AlexxIT";
    repo = "go2rtc";
    rev = "refs/tags/v${version}";
    hash = "sha256-GqZs11g05xc3Nob/jqGbG/rFYBhyEPNdXYJuJBiAyko=";
  };

  vendorHash = "sha256-5c3oauklMD9fEnVGPyWq6hR5jz6pSnq2kmdq+0JBfpo=";

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
