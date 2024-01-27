{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g4z6UMTdg5Vjrn6h/t42GpHiAgZtTEi3AdS3X8Ho3fI=";
  };

  vendorHash = "sha256-/TvKx0xUI6XktkvPoZFWINQXf2hckfOn4QxYpGfEPl4=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}"
  ];

  passthru.tests = { inherit (nixosTests) mediamtx; };

  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
}
