{ lib, fetchurl }:

rec {
  name = "mingwrt-3.20";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/mingw-rt/${name}-mingw32-src.tar.gz";
    sha256 = "02pydg1m8y35nxb4k34nlb5c341y2waq76z42mgdzlcf661r91pi";
  };

  meta.platforms = [ lib.systems.inspect.isMinGW ];
}
