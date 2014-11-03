{ stdenv, lib, fetchurl, xorg, pixman, pkgconfig }:

let version = "1.3.1";
in stdenv.mkDerivation {
  name = "quartz-wm-${version}";
  src = fetchurl {
    url = "http://xquartz-dl.macosforge.org/src/quartz-wm-${version}.tar.xz";
    sha256 = "1j8zd3p7rhay1s3sxq6anw78k5s59mx44xpqla2ianl62346a5g9";
  };
  patches = [
    ./no_title_crash.patch
    ./extern-patch.patch
  ];
  buildInputs = [
    xorg.libXinerama
    xorg.libAppleWM
    xorg.applewmproto
    xorg.libXrandr
    xorg.libXext
    pixman
    pkgconfig
  ];
  meta = with lib; {
    license = licenses.apsl20;
    platforms = platforms.darwin;
  };
}
