{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "mingwrt-5.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/mingw-rt/${name}-mingw32-src.tar.gz";
    sha256 = "02pydg1m8y35nxb4k34nlb5c341y2waq76z42mgdzlcf661r91p0";
  };

  meta = {
    platforms = lib.platforms.windows;
  };

  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];
}
