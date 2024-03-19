{ lib, stdenv, fetchurl, xorg, pixman, pkg-config, AppKit, Foundation, Xplugin }:

let version = "1.3.1";
in stdenv.mkDerivation {
  pname = "quartz-wm";
  inherit version;
  src = fetchurl {
    url = "http://xquartz-dl.macosforge.org/src/quartz-wm-${version}.tar.xz";
    sha256 = "1j8zd3p7rhay1s3sxq6anw78k5s59mx44xpqla2ianl62346a5g9";
  };
  patches = [
    ./no_title_crash.patch
    ./extern-patch.patch
  ];
  configureFlags = [ "--enable-xplugin-dock-support" ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libXinerama
    xorg.libAppleWM
    xorg.xorgproto
    xorg.libXrandr
    xorg.libXext
    pixman
    AppKit Xplugin Foundation
  ];
  meta = with lib; {
    license = licenses.apsl20;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
