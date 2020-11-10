{ stdenv, lib, fetchurl, pkgconfig, perl
, libjpeg, udev
, withUtils ? true
, withGUI ? true, alsaLib, libX11, qtbase, libGLU, wrapQtAppsHook
}:

# See libv4l in all-packages.nix for the libs only (overrides alsa, libX11 & QT)

let
  withQt = withUtils && withGUI;

# we need to use stdenv.mkDerivation in order not to pollute the libv4l’s closure with Qt
in stdenv.mkDerivation rec {
  pname = "v4l-utils";
  version = "1.20.0";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1xr66y6w422hil6s7n8d61a2vhwh4im8l267amf41jvw7xqihqcm";
  };

  outputs = [ "out" ] ++ lib.optional withUtils "lib" ++ [ "dev" ];

  configureFlags = (if withUtils then [
    "--with-localedir=${placeholder "lib"}/share/locale"
    "--with-udevdir=${placeholder "out"}/lib/udev"
  ] else [
    "--disable-v4l-utils"
  ]);

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [ pkgconfig perl ] ++ lib.optional withQt wrapQtAppsHook;

  buildInputs = [ udev ] ++ lib.optionals withQt [ alsaLib libX11 qtbase libGLU ];

  propagatedBuildInputs = [ libjpeg ];

  postPatch = ''
    patchShebangs utils/cec-ctl/msg2ctl.pl
    patchShebangs utils/libcecutil/cec-gen.pl
  '';

  meta = with stdenv.lib; {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = "https://linuxtv.org/projects.php";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
