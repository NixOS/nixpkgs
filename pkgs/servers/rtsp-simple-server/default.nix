{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-diBMOVEZYKQlGBTU6pZpc1pG71Ad0qbXc+NLLxTczFk=";
  };

  vendorSha256 = "sha256-62Jayh1blz5tbRtYxpPaSCJkRgpaTIcmw7lCuJ0JtIU=";

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
