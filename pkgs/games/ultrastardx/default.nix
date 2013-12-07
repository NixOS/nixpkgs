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
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath ${SDL}/lib -rpath ${SDL_image}/lib -rpath ${libpng}/lib -rpath ${freetype}/lib -rpath ${portaudio}/lib -rpath ${ffmpeg}/lib -rpath ${zlib}/lib -rpath ${sqlite}/lib -rpath ${libX11}/lib -rpath ${pcre}/lib -rpath ${lua}/lib -rpath ${stdenv.gcc.gcc}/lib64 -rpath ${stdenv.gcc.gcc}/lib"

    sed -i 414,424d Makefile
  '';

  # dlopened libgcc requires the rpath not to be shrinked
  dontPatchELF = true;

  meta = {
    homepage = http://ultrastardx.sourceforge.net/;
    description = "Free and open source karaoke game";
    license = "GPLv2+";
  };
}
