{ stdenv, fetchurl, xz, lib }:

stdenv.mkDerivation rec {
  name = "w32api-3.17-2";

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/w32api/w32api-3.17/${name}-mingw32-src.tar.lzma";
    sha256 = "09rhnl6zikmdyb960im55jck0rdy5z9nlg3akx68ixn7khf3j8wb";
  };

  meta = {
    platforms = lib.platforms.windows;
  };

  dontStrip = true;
}
