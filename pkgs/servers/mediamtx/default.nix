{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "0.23.8";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ICH102Z18dbabXVYgxCX4JTQ75v0A9wx2pIsZHIXDFg=";
  };

  vendorHash = "sha256-uqcv05AHwwPxrix+FWSWpV8vKFqKQsMn8qEgD71zgo8=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}"
  ];

  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}
