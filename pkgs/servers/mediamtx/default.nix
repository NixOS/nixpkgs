{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HdFq48+jpkl3UkfTyyrYllK5WM4ij4Qwqmf1bNstLAY=";
  };

  vendorHash = "sha256-Z9lm6Gw8q/6kK3AjF1A6zMryUJaKAO9bhXvBoBdlTaM=";

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
