{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9PjITPuCndz/EuFEt9docmWN93TwZQbnyHV161hUwS0=";
  };

  vendorSha256 = "sha256-6tp1hN1dRKm523IegMpsTO+/gktywqdNZflUbE4TPuU=";

  # Tests need docker
  doCheck = false;

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
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
