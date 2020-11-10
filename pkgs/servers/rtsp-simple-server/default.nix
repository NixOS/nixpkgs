{ stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "rtsp-simple-server";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "aler9";
    repo = pname;
    rev = "v${version}";
    sha256 = "rnUmPyT9jAqm7Vf2TokgRGPTn7rTBUvrpJU21IopFsM=";
  };

  vendorSha256 = "jAWDz/TclfCKQR/Gh99zSiGAsraciNU+yzFe5DGTeQI=";

  # Tests need docker
  doCheck = false;

  buildFlagsArray = [
    "-ldflags=-X main.Version=${version}"
  ];

  meta = with stdenv.lib; {
    description =
      "Ready-to-use RTSP server and RTSP proxy that allows to read and publish video and audio streams"
    ;
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };

}
