{ stdenv, lib, fetchurl, pkgconfig, perl, makeQtWrapper
, libjpeg, udev
, withUtils ? true
, withGUI ? true, alsaLib, libX11, qtbase, mesa_glu
}:

# See libv4l in all-packages.nix for the libs only (overrides alsa, libX11 & QT)

stdenv.mkDerivation rec {
  name = "v4l-utils-${version}";
  version = "1.12.3";

  src = fetchurl {
    url = "http://linuxtv.org/downloads/v4l-utils/${name}.tar.bz2";
    sha256 = "0vpl3jl0x441y7b5cn7zhdsyi954hp9h2p30jhnr1zkx1rpxsiss";
  };

  outputs = [ "out" "dev" ];

  configureFlags =
    if withUtils then [
      "--with-udevdir=\${out}/lib/udev"
    ] else [
      "--disable-v4l-utils"
    ];

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [ pkgconfig perl ] ++ lib.optional (withUtils && withGUI) makeQtWrapper;

  buildInputs = [ udev ] ++ lib.optionals (withUtils && withGUI) [ alsaLib libX11 qtbase mesa_glu ];

  propagatedBuildInputs = [ libjpeg ];

  NIX_CFLAGS_COMPILE = lib.optional (withUtils && withGUI) "-std=c++11";

  postPatch = ''
    patchShebangs .
  '';

  postInstall = lib.optionalString (withUtils && withGUI) ''
    wrapQtProgram $out/bin/qv4l2
  '';

  meta = with stdenv.lib; {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = http://linuxtv.org/projects.php;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ codyopel viric ];
    platforms = platforms.linux;
  };
}
