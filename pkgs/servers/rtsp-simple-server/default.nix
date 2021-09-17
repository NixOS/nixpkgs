{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9V6yblRnOAZBYuGChjeDyOTWjCCVhdFxljSndEr7GdY=";
  };

  vendorSha256 = "sha256-lFyRMoI+frzAa7sL8wIzUgzJRrCQjt9Ri8T9pHIpoug=";

  # Tests need docker
  doCheck = false;

  # In the future, we might need to switch to `main.Version`, considering:
  # https://github.com/aler9/rtsp-simple-server/issues/503
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
