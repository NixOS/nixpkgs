{ stdenv, fetchurl, cmake, gnome, boost155, pcre, freetype, mesa, glew, glib, gtk2, libjpeg, libpng, SDL, SDL_mixer, libupnp, xorg, zlib, pkgconfig, gtest, libxml2}:

stdenv.mkDerivation rec {
  version = "5.4.1";
  name = "openclonk-${version}";

  src = fetchurl {
    url = "http://archive.ubuntu.com/ubuntu/pool/universe/o/openclonk/openclonk_${version}.orig.tar.xz";
    sha256 = "12cq3y7djbiv7rzjspqyb053cj5vg3s5pallycip93y1m1w7i9bz";
  };

  enableParallelBuilding = true;

  buildInputs = [
    cmake boost155 gnome.gtksourceview pcre freetype mesa glew glib gtk2 libjpeg
    libpng SDL SDL_mixer libupnp xorg.libX11 xorg.libXrandr xorg.libpthreadstubs
    xorg.libXdmcp libxml2 zlib pkgconfig gtest
  ];

  postInstall = "mv -v $out/games/openclonk $out/bin/";

  meta = with stdenv.lib; {
    description = "Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings";
    homepage = "http://openclonk.org";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
