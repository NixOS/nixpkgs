{ lib
, fetchFromGitHub
, fetchurl
, buildGoModule
, nixosTests
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.8/dist/hls.min.js";
    hash = "sha256-KG8Cm0dAsFbrBHuMi9c+bMocpSvWWK4c9aWH9LGfDY4=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4ypAM1dW13qKaCEXGET1Xe2+kDBEwJHaOQ1ZghFymFM=";
  };

  vendorHash = "sha256-+K772WVLRaLXZgpULwv8/pL5zbHpvhbMikSqMF9MOs4=";

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
