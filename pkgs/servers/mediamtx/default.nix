{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Upm/fiW3hXzBS+IpwzE3C6h6Z7ZpA2k+j2UqAWT8hF0=";
  };

  vendorHash = "sha256-uaOfULtZ+BdbX1TmDyZtYnoXV8579RSW6eocmPsXyP8=";

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
