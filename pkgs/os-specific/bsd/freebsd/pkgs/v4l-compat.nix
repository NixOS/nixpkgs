{
  lib,
  stdenv,
  fetchurl,
}:
let
  types_h = fetchurl {
    url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/3da53417998c611f340d75e45962da2fa912add5/multimedia/libv4l/files/types.h";
    hash = "sha256-vbw82kxDC02vFhqdK3klh52pk/ecL+HwmmgQYYMEV9w=";
  };
  videodev_h = fetchurl {
    url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/3da53417998c611f340d75e45962da2fa912add5/multimedia/libv4l/files/videodev.h";
    hash = "sha256-tcSZeBkaRo+K6i/tUYjhgQdEAuMhstvWsyVydIevAU4=";
  };
in
stdenv.mkDerivation rec {
  pname = "v4l-compat";
  version = "5.8";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
    hash = "sha256-5/dRhqoGQhFK+PGdmVWZNzAMonrK90UbNtT5sPhc8fU=";
  };
  allFiles = [
    "linux/cec.h"
    "linux/cec-funcs.h"
    "linux/const.h"
    "linux/dvb/audio.h"
    "linux/dvb/ca.h"
    "linux/dvb/dmx.h"
    "linux/dvb/frontend.h"
    "linux/dvb/net.h"
    "linux/dvb/osd.h"
    "linux/dvb/version.h"
    "linux/dvb/video.h"
    "linux/ivtv.h"
    "linux/lirc.h"
    "linux/media.h"
    "linux/media-bus-format.h"
    "linux/v4l2-common.h"
    "linux/v4l2-controls.h"
    "linux/v4l2-mediabus.h"
    "linux/v4l2-subdev.h"
    "linux/videodev2.h"
  ];

  buildPhase = ":";

  installPhase = ''
    for f in $allFiles; do
      mkdir -p $(dirname $out/include/$f)
      cp include/uapi/$f $out/include/$f
    done
    cp ${types_h} $out/include/linux/types.h
    cp ${videodev_h} $out/include/linux/videodev.h
  '';

  meta = {
    description = "Video4Linux header files for FreeBSD";
    maintainers = [ lib.maintainers.rhelmot ];
    platforms = lib.platforms.freebsd;
    license = lib.licenses.gpl2Only;
  };
}
