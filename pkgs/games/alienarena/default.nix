{ stdenv, fetchurl, pkgconfig, libjpeg, libX11, libXxf86vm, curl, libogg
, libvorbis, freetype, openal, mesa }:
stdenv.mkDerivation rec {
  name = "alienarena-7.52";
  src = fetchurl {
    url = "http://icculus.org/alienarena/Files/alienarena-7_52-linux20110929.tar.gz";
    sha256 = "1s1l3apxsxnd8lyi568y38a1fcdr0gwmc3lkgq2nkc676k4gki3m";
  };
  buildInputs = [ pkgconfig libjpeg libX11 curl libogg libvorbis
                  freetype openal mesa libXxf86vm ];
  patchPhase = ''
    substituteInPlace ./configure \
      --replace libopenal.so.1 ${openal}/lib/libopenal.so.1
  '';
  meta = {
    description = "A free, stand-alone first-person shooter computer game";
    longDescription = ''
      Do you like old school deathmatch with modern features? How
      about rich, colorful, arcade-like atmospheres? How about retro
      Sci-Fi? Then you're going to love what Alien Arena has in store
      for you! This game combines some of the very best aspects of
      such games as Quake III and Unreal Tournament and wraps them up
      with a retro alien theme, while adding tons of original ideas to
      make the game quite unique.
    '';
    homepage = http://red.planetarena.org;
    # Engine is under GPLv2, everything else is under
    license = [ "unfree-redistributable" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
