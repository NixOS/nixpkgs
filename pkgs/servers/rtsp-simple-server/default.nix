{ lib, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "094brxiiapm7402q0ysaha2xk3wymc2kz8vqisjyiswz7wf4wsx0";
  };

  vendorSha256 = "007dyw825jsfma7sq5llxllhrzbkhqxr985s1nhg5cdd803gz42p";

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
