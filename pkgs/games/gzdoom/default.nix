{ stdenv, fetchFromGitHub, cmake, zdoom
, openal, fluidsynth, soundfont-fluid, mesa_noglu, SDL2
, bzip2, zlib, libjpeg, libsndfile, mpg123, game-music-emu }:

stdenv.mkDerivation rec {
  name = "gzdoom-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "coelckers";
    repo = "gzdoom";
    rev = "g${version}";
    sha256 = "0xxgd8fa29pcdir1xah5cvx41bfy76p4dydpp13mf44p9pr29hrb";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2 mesa_noglu openal fluidsynth bzip2 zlib libjpeg libsndfile mpg123
    game-music-emu
  ];

  enableParallelBuilding = true;

  NIX_CFLAGS_LINK = [ "-lopenal" "-lfluidsynth" ];

  preConfigure = ''
    sed -i \
      -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
      -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
      src/sound/music_fluidsynth_mididevice.cpp
  '';

  installPhase = ''
    install -Dm755 gzdoom "$out/lib/gzdoom/gzdoom"
    for i in *.pk3; do
      install -Dm644 "$i" "$out/lib/gzdoom/$i"
    done
    mkdir $out/bin
    ln -s $out/lib/gzdoom/gzdoom $out/bin/gzdoom
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/coelckers/gzdoom";
    description = "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
    # Doom source license, MAME license
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus ];
  };
}

