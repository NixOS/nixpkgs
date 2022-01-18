{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wjF7XTiUw5lPSmNiHvqUz4ZswpzLBoYF9S25dL8VPMU=";
  };

  vendorSha256 = "sha256-rntfePkwNGnyPjIzjLJhBYLTcndHP605Ah/xPcM6sRo=";

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
