{ lib
, stdenv
, fetchgit
, autoreconfHook
, coreutils
, glib
, gnugrep
, gst_all_1
, icamerasrc
, libtool
, makeWrapper
, pkg-config
, which
}:
let
  gst = [
    gst_all_1.gstreamer.out
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    icamerasrc
  ];
in
stdenv.mkDerivation rec {
  pname = "v4l2-relayd-${icamerasrc.ipuVersion}";
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
    makeWrapper
    pkg-config
    which
  ];

  buildInputs = [
    glib
  ] ++ gst;

  preConfigure = "./autogen.sh --prefix=$out";

  postInstall = ''
    mkdir -p $out/lib/systemd/system $out/etc/default
    cp data/systemd/v4l2-relayd.service $out/lib/systemd/system
    cp data/etc/default/v4l2-relayd $out/etc/default

    substituteInPlace $out/lib/systemd/system/v4l2-relayd.service \
      --replace grep ${gnugrep}/bin/grep \
      --replace cut ${coreutils}/bin/cut \
      --replace /usr/bin/test ${coreutils}/bin/test \
      --replace /usr/bin/v4l2-relayd $out/bin/v4l2-relayd \
      --replace /etc/default $out/etc/default \
      --replace "DeviceAllow=char-video4linux" ""

    substituteInPlace $out/etc/default/v4l2-relayd \
      --replace 'FORMAT=YUY2' 'FORMAT=NV12' \
      --replace 'CARD_LABEL="Virtual Camera"' 'CARD_LABEL="Intel MIPI Camera"' \
      --replace 'VIDEOSRC="videotestsrc"' 'VIDEOSRC="icamerasrc"'

    wrapProgram $out/bin/v4l2-relayd \
      --prefix GST_PLUGIN_PATH : ${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gst}
  '';

  meta = with lib; {
    description = "Streaming relay for v4l2loopback using GStreamer";
    homepage = "https://git.launchpad.net/v4l2-relayd";
    license = licenses.gpl2;
    maintainers = with maintainers; [ betaboon ];
    platforms = [ "x86_64-linux" ];
  };
}
