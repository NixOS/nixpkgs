{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z9fqR2iK7HOpWNFnrIkNzy0peY6v9QLOyUYbVXp1aNU=";
  };

  vendorHash = "sha256-az2jHhd3YzI7phRRXBWRcAsISgipPN20SRncsfu58fM=";

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
