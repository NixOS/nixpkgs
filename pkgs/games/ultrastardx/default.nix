{stdenv, fetchurl, pkgconfig, lua, fpc, pcre, portaudio, freetype, libpng
, SDL, SDL_image, ffmpeg, sqlite, zlib, libX11 }:

stdenv.mkDerivation rec {
  name = "ultrastardx-1.1";
  src = fetchurl {
    url = "mirror://sourceforge/ultrastardx/${name}-src.tar.gz";
    sha256 = "0sfj5rfgj302avcp6gj5hiypcxms1wc6h3qzjaf5i2a9kcvnibcd";
  };

  buildInputs = [ pkgconfig fpc pcre portaudio freetype libpng SDL SDL_image ffmpeg
    sqlite lua ];


  # The fpc is not properly wrapped to add -rpath. I add this manually.
  # I even do a trick on lib/lib64 for libgcc, that I expect it will work.
  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath ${SDL.out}/lib -rpath ${SDL_image}/lib -rpath ${libpng.out}/lib -rpath ${freetype.out}/lib -rpath ${portaudio}/lib -rpath ${ffmpeg.out}/lib -rpath ${zlib.out}/lib -rpath ${sqlite.out}/lib -rpath ${libX11.out}/lib -rpath ${pcre.out}/lib -rpath ${lua}/lib -rpath ${stdenv.cc.cc.out}/lib64 -rpath ${stdenv.cc.cc.out}/lib"

    sed -i 414,424d Makefile
  '';

  # dlopened libgcc requires the rpath not to be shrinked
  dontPatchELF = true;

  meta = {
    homepage = http://ultrastardx.sourceforge.net/;
    description = "Free and open source karaoke game";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
