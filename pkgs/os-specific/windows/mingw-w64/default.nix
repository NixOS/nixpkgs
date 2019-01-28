{ stdenv, windows, fetchurl }:

let
  version = "5.0.4";
in stdenv.mkDerivation {
  name = "mingw-w64-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "00zq3z1hbzd5yzmskskjg79xrzwsqx7ihyprfaxy4hb897vf29sm";
  };

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];

  buildInputs = [ windows.mingw_w64_headers ];
  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];
  patches = [ ./osvi.patch ];

  meta = {
    platforms = stdenv.lib.platforms.windows;
  };
}
