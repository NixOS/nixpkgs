{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NGUEDOME6jzckHrzOboQr5KrZ8Z4iLCTHGCRGhbQThU=";
  };

  vendorHash = "sha256-7+0+F1dW70GXjOzJ/+KTFZPp8o1w2wDvQlX0Zrrx7qU=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/aler9/mediamtx/internal/core.version=v${version}"
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
