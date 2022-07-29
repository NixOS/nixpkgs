{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nIxh6mbpkM5vX0S2ze8ylfEP1B07/DaqjoF8jDirJb8=";
  };

  vendorSha256 = "sha256-zz2RLmljfOw5DtQuFkfS47yHq/bWMJzmmJf+PBlPJJQ=";

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
