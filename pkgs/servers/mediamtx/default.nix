{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x+4dU+SHkkF0E/NoVvK0aNBCyAIL3Nfbh1tBVe//nx0=";
  };

  vendorHash = "sha256-pcHtmkYV3hqb6QQ7O6WQSHqwuYWFq3Xx6vhPAIyuFEI=";

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
