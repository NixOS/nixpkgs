{
  mkKdeDerivation,
  pkg-config,

  qtmultimedia,

  alsa-lib,
  audiofile,
  fftw,
  flac,
  id3lib,
  libogg,
  libopus,
  libmad,
  libpulseaudio,
  libsamplerate,
  libvorbis,
}:
mkKdeDerivation {
  pname = "kwave";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtmultimedia

    alsa-lib
    audiofile
    fftw
    flac
    id3lib
    libogg
    libopus
    libmad
    libpulseaudio
    libsamplerate
    libvorbis
  ];
}
