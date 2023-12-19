{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o4O0WoLnGFz/cV6GC92yFwdu5dSAE8x906Ln6JfaJdY=";
  };

  vendorHash = "sha256-8pFD51uf7CCAI9gart/QkcrBifeiJkyTYu8nIC83j7o=";

  # Tests need docker
  doCheck = false;

  ldflags = [
    "-X github.com/bluenviron/mediamtx/internal/core.version=v${version}"
  ];

  passthru.tests = { inherit (nixosTests) mediamtx; };

  meta = with lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    mainProgram = "mediamtx";
    maintainers = with maintainers; [ fpletz ];
  };
}
