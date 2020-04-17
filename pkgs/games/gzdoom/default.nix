{ stdenv, fetchFromGitHub, cmake, makeWrapper
, openal, fluidsynth_1, soundfont-fluid, libGL, SDL2
, bzip2, zlib, libjpeg, libsndfile, mpg123, game-music-emu }:

stdenv.mkDerivation rec {
  pname = "gzdoom";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "coelckers";
    repo = "gzdoom";
    rev = "g${version}";
    sha256 = "1c4vhnvvwy1rs8xm01kqd486h5xsiccwkf95fjx7912zr49yalks";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    SDL2 libGL openal fluidsynth_1 bzip2 zlib libjpeg libsndfile mpg123
    game-music-emu
  ];

  enableParallelBuilding = true;

  NIX_CFLAGS_LINK = "-lopenal -lfluidsynth";

  preConfigure = ''
    sed -i \
      -e "s@/usr/share/sounds/sf2/@${soundfont-fluid}/share/soundfonts/@g" \
      -e "s@FluidR3_GM.sf2@FluidR3_GM2-2.sf2@g" \
      libraries/zmusic/mididevices/music_fluidsynth_mididevice.cpp
  '';

  installPhase = ''
    install -Dm755 gzdoom "$out/lib/gzdoom/gzdoom"
    for i in *.pk3; do
      install -Dm644 "$i" "$out/lib/gzdoom/$i"
    done
    for i in fm_banks/*; do
      install -Dm644 "$i" "$out/lib/gzdoom/$i"
    done
    for i in soundfonts/*; do
      install -Dm644 "$i" "$out/lib/gzdoom/$i"
    done
    mkdir $out/bin
    makeWrapper $out/lib/gzdoom/gzdoom $out/bin/gzdoom
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/coelckers/gzdoom";
    description = "A Doom source port based on ZDoom. It features an OpenGL renderer and lots of new features";
    license = licenses.gpl3;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [ lassulus ];
  };
}
