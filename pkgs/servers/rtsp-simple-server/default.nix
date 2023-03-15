{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.21.6";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b9sb5XU+wE14N4N7NELE26gSntu7wJgpneIF+T2w6WY=";
  };

  vendorHash = "sha256-rKmaxsDQ6+cLp6eaw8TRjpPsNcQlPauqmX6hcslc2Wo=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/aler9/rtsp-simple-server/internal/core.version=v${version}"
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
