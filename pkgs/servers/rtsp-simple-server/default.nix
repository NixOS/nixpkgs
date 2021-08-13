{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8g9taSFEprJEEPM0hrbCf5QDE41uVdgVVIWjhfEICpU=";
  };

  vendorSha256 = "sha256-buQW5jMnHyHc/oYdmfTnoktFRG3V3SNxn7t5mAwmiJI=";

  # Tests need docker
  doCheck = false;

  buildFlagsArray = [
    # In the future, we might need to switch to `main.Version`, considering:
    # https://github.com/aler9/rtsp-simple-server/issues/503
    "-ldflags=-X github.com/aler9/rtsp-simple-server/internal/core.version=v${version}"
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
