{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U0wZ0NrvCQjMLDDjO6Jf6uu5FlHar7Td2zhoU2+MMkM=";
  };

  vendorSha256 = "sha256-dfAuq4iw3NQ4xaabPv7MQ88CYXgivRBeyvbmJ3SSjbI=";

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
