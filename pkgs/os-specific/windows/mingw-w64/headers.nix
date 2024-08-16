{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mingw_w64-headers";
  version = "11.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-P2a84Gnui+10OaGhPafLkaXmfqYXDyExesf1eUYl7hA=";
  };

  preConfigure = ''
    cd mingw-w64-headers
  '';

  meta = {
    platforms = lib.platforms.windows;
  };
})
