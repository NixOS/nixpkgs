{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6XdX4HEjDRt9WtqyHIv/NLt7IytNDeJLgCeTHTGybRI=";
  };

  vendorSha256 = "sha256-T5LWbxYsKnG5eaYLR/rms6+2DXv2lV9o39BvF7HapZY=";

  # Tests need docker
  doCheck = false;

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };

}
