{ stdenv, lib, fetchurl, pkgconfig, perl
, libjpeg, udev
, withUtils ? true
, withGUI ? true, alsaLib, libX11, qtbase, libGLU
}:

# See libv4l in all-packages.nix for the libs only (overrides alsa, libX11 & QT)

stdenv.mkDerivation rec {
  name = "v4l-utils-${version}";
  version = "1.16.2";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    sha256 = "0iwfdp4ghzd6l9qg5545032vwmqy2rnhk0xf1g9mad67l74hhckc";
  };

  outputs = [ "out" "dev" ];

  configureFlags =
    if withUtils then [
      "--with-udevdir=${placeholder "out"}/lib/udev"
    ] else [
      "--disable-v4l-utils"
    ];

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ udev ] ++ lib.optionals (withUtils && withGUI) [ alsaLib libX11 qtbase libGLU ];

  propagatedBuildInputs = [ libjpeg ];

  NIX_CFLAGS_COMPILE = lib.optional (withUtils && withGUI) "-std=c++11";

  postPatch = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = https://linuxtv.org/projects.php;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
