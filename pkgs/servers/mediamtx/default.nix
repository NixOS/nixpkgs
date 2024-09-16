{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.15/dist/hls.min.js";
    hash = "sha256-qRwhj9krOcLJKbGghAC8joXfNKXUdN7OkgEDosUWdd8=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iCUCQLMWB0cH9SuudP1KvSD1X58hvYgE30nIh2FpKlY=";
  };

  vendorHash = "sha256-TiI02M6k1zN/iWJntOfc9EY5xFo3ESOtdDSumxYmSU0=";

  postPatch = ''
    cp ${hlsJs} internal/servers/hls/hls.min.js
  '';

  # Tests need docker
  doCheck = false;

  ldflags = [ "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}" ];

  passthru.tests = {
    inherit (nixosTests) mediamtx;
  };

  meta = with lib; {
    description = "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams";
    inherit (src.meta) homepage;
    license = licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
}
