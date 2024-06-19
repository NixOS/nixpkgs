{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, fftw
, zita-convolver
, fftwFloat
, libsndfile
, ffmpeg
, alsa-lib
, libao
, libmad
, ladspaH
, libtool
, libpulseaudio
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsp";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "bmc0";
    repo = "dsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S1pzVQ/ceNsx0vGmzdDWw2TjPVLiRgzR4edFblWsekY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fftw
    zita-convolver
    fftwFloat
    libsndfile
    ffmpeg
    alsa-lib
    libao
    libmad
    ladspaH
    libtool
    libpulseaudio
  ];

  meta = with lib; {
    homepage = "https://github.com/bmc0/dsp";
    description = "Audio processing program with an interactive mode";
    license = licenses.isc;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.linux;
    mainProgram = "dsp";
  };
})
