{ lib
, stdenv
, fetchgit
, autoreconfHook
, glib
, gst_all_1
, libtool
, pkg-config
, which
}:
stdenv.mkDerivation rec {
  pname = "v4l2-relayd";
  version = "0.1.3";

  src = fetchgit {
    url = "https://git.launchpad.net/v4l2-relayd";
    rev = "refs/tags/upstream/${version}";
    hash = "sha256-oU6naDFZ0PQVHZ3brANfMULDqYMYxeJN+MCUCvN/DpU=";
  };

  patches = [
    ./upstream-v4l2loopback-compatibility.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  preConfigure = "./autogen.sh --prefix=$out";

  meta = with lib; {
    description = "Streaming relay for v4l2loopback using GStreamer";
    homepage = "https://git.launchpad.net/v4l2-relayd";
    license = licenses.gpl2;
    maintainers = with maintainers; [ betaboon ];
    platforms = [ "x86_64-linux" ];
  };
}
