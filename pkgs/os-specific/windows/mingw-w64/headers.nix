{
  lib,
  stdenvNoCC,
  fetchurl,
  crt ? stdenvNoCC.hostPlatform.libc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mingw_w64-headers";
  version = "12.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-zEGJiqxLbo3Vz/1zMbnZUVuRLfRCCjphK16ilVu+7S8=";
  };

  configureFlags = [
    (lib.withFeatureAs true "default-msvcrt" crt)
  ];

  preConfigure = ''
    cd mingw-w64-headers
  '';

  meta = {
    platforms = lib.platforms.windows;
  };
})
