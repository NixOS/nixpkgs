{ stdenv, windows, fetchurl }:

let
  version = "5.0.4";
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "00zq3z1hbzd5yzmskskjg79xrzwsqx7ihyprfaxy4hb897vf29sm";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];

  enableParallelBuilding = true;

  buildInputs = [ windows.mingw_w64_headers ];
  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];
  patches = [ ./osvi.patch ];

  meta = {
    platforms = stdenv.lib.platforms.windows;
  };
}
