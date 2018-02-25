{ stdenv, fetchurl, cmake, gnome3, pcre, freetype, glew, gtk3, libjpeg, libpng,
  SDL, SDL_mixer, libupnp, xorg, pkgconfig, gtest, tinyxml, gmock, readline,
  libxkbcommon, epoxy, at-spi2-core, dbus, libxml2,
  enableSoundtrack ? false # Enable the "Open Clonk Soundtrack - Explorers Journey" by David Oerther
}:

let
  soundtrack_src = fetchurl {
    url = "http://www.openclonk.org/download/Music.ocg";
    sha256 = "1ckj0dlpp5zsnkbb5qxxfxpkiq76jj2fgj91fyf3ll7n0gbwcgw5";
  };
in stdenv.mkDerivation rec {
  version = "7.0";
  name = "openclonk-${version}";

  src = fetchurl {
    url = "http://www.openclonk.org/builds/release/7.0/openclonk-${version}-src.tar.bz2";
    sha256 = "0ch71dqaaalg744pc1gvg6sj2yp2kgvy2m4yh6l7ljkpf8fj66mw";
  };

  postInstall = ''
    mv -v $out/games/openclonk $out/bin/
  '' + stdenv.lib.optionalString enableSoundtrack ''
    cp -v ${soundtrack_src} $out/share/games/openclonk/Music.ocg
  '';

  enableParallelBuilding = true;

  buildInputs = [
    cmake gnome3.gtksourceview pcre freetype glew gtk3 libjpeg libpng SDL
    SDL_mixer libupnp tinyxml xorg.libpthreadstubs libxkbcommon xorg.libXdmcp
    pkgconfig gtest gmock readline epoxy at-spi2-core dbus libxml2
  ];

  meta = with stdenv.lib; {
    description = "Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings";
    homepage = http://openclonk.org;
    license = if enableSoundtrack then licenses.unfreeRedistributable else licenses.isc;
    platforms = platforms.all;
  };
}
