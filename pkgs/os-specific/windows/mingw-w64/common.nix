{ fetchurl }:

rec {
  version = "5.0.4";
  name = "mingw-w64-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "00zq3z1hbzd5yzmskskjg79xrzwsqx7ihyprfaxy4hb897vf29sm";
  };
}
