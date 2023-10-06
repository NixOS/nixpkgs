{ lib
, fetchFromGitHub
, buildGoModule
, nixosTests
}:

buildGoModule rec {
  pname = "mediamtx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bluenviron";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XD7m6vp7Xu/Fmtv9smzz+zwVosP8UAOUkE+6KRAfVMQ=";
  };

  vendorHash = "sha256-Mnyc7PL6nUyoCnS6Mm+EGsxV8ciq0x4GXdbwslOs9hw=";

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
