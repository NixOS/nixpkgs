{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "mingwrt";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/mingwrt/mingwrt-${version}/mingwrt-${version}-mingw32-src.tar.xz";
    sha256 = "1vj6f578wcffdmy7zzf7xz1lw57kxjy08j0k1n28f0j4ylrk68vp";
  };

  meta = {
    platforms = lib.platforms.windows;
  };

  dontStrip = true;
  hardeningDisable = [
    "stackprotector"
    "fortify"
  ];
}
