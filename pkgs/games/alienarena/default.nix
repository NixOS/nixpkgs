{ curl
, fetchFromGitHub
, freetype
, lib
, libGL
, libjpeg
, libogg
, libvorbis
, libX11
, libXxf86vm
, openal
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "alienarena";
  version = "7.71.6";

  src = fetchFromGitHub {
    owner = "alienarena";
    repo = "alienarena";
    rev = version;
    hash = "sha256-Dml0VY5VQiWLq8LjItBSzNwJB9L4biJ/nJWmEGtG2ZY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    freetype
    libGL
    libjpeg
    libogg
    libvorbis
    libX11
    libXxf86vm
    openal
  ];

  patchPhase = ''
    substituteInPlace ./configure \
      --replace libopenal.so.1 ${openal}/lib/libopenal.so.1 \
      --replace libGL.so.1 ${libGL}/lib/libGL.so.1
  '';

  meta = with lib; {
    changelog = "https://github.com/alienarena/alienarena/releases/tag/${version}";
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
    homepage = "https://alienarena.org";
    # Engine is under GPLv2, everything else is under
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
