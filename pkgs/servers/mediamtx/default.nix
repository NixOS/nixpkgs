{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  nixosTests,
}:

let
  hlsJs = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/hls.js@v1.5.13/dist/hls.min.js";
    hash = "sha256-5XU7EPxl6uNfIYg+aE0ixDzmbelo01FmeSWFubij8aI=";
  };
in
buildGoModule rec {
  pname = "mediamtx";
  # check for hls.js version updates in internal/servers/hls/hlsjsdownloader/VERSION
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wBavNhyscjWzgz+iwY2uB2vI8z0sWdfMM9Zpwi3obm4=";
  };

  vendorHash = "sha256-UQM1MFDhIo2NkxHvr054SB0YzjP/LHDeS9An0k9Q6Ls=";

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
