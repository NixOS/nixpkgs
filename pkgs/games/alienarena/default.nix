{ lib, stdenv, fetchsvn, pkg-config, libjpeg, libX11, libXxf86vm, curl, libogg
, libvorbis, freetype, openal, libGL }:

stdenv.mkDerivation rec {
  pname = "alienarena";
  version = "7.71.2";

  src = fetchsvn {
    url = "svn://svn.icculus.org/alienarena/trunk";
    rev = "5673";
    sha256 = "1qfrgrp7nznk5n1jqvjba6l1w8y2ixzyx9swkpvd02rdwlwrp9kw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libjpeg libX11 curl libogg libvorbis
                  freetype openal libGL libXxf86vm ];

  patchPhase = ''
    substituteInPlace ./configure \
      --replace libopenal.so.1 ${openal}/lib/libopenal.so.1 \
      --replace libGL.so.1 ${libGL}/lib/libGL.so.1
  '';

  meta = with lib; {
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
    homepage = "http://red.planetarena.org";
    # Engine is under GPLv2, everything else is under
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
