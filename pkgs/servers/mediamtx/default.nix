{ lib
, fetchFromGitHub
, fetchurl
, buildGoModule
, nixosTests
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.11/dist/hls.min.js";
    hash = "sha256-N10eCJk75KlKpHVXtwgC7vBDrU5b7ZQng9o/QK93m2w=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/r5N9RSlYH6xM+JyETuTQWu0YTvaShI6APi8ibpP7Zg=";
  };

  vendorHash = "sha256-/TgSTXA6SOCfm/wtjJBtyIg4Fo0moJyC640zoIOQ4Fo=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
  '';

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
