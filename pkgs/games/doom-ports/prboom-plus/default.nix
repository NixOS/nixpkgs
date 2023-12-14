{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
, SDL2_mixer
, SDL2_image
, SDL2_net
, fluidsynth
, soundfont-fluid
, portmidi
, dumb
, libvorbis
, libmad
, pcre
}:

stdenv.mkDerivation rec {
  pname = "prboom-plus";
  version = "2.6.66";

  src = fetchFromGitHub {
    owner = "coelckers";
    repo = "prboom-plus";
    rev = "v${version}";
    sha256 = "sha256-moU/bZ2mS1QfKPP6HaAwWP1nRNZ4Ue5DFl9zBBrJiHw=";
  };

  sourceRoot = "${src.name}/prboom2";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_image
    SDL2_net
    fluidsynth
    portmidi
    dumb
    libvorbis
    libmad
    pcre
  ];

  # Fixes impure path to soundfont
  prePatch = ''
    substituteInPlace src/m_misc.c --replace \
      "/usr/share/sounds/sf3/default-GM.sf3" \
      "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
  '';

  meta = with lib; {
    homepage = "https://github.com/coelckers/prboom-plus";
    description = "An advanced, Vanilla-compatible Doom engine based on PrBoom";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.ashley ];
  };
}
