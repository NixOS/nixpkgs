{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dg+Xl3yHiWJPV+3iFcMVCPHOpHo0+pFiJv+ZVXDAK6k=";
  };

  vendorHash = "sha256-KvG0+wxe0D+TxQmxaskTa228zUlOxCZE9rGqMYkdwzM=";

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
